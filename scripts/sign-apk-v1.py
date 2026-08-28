#!/usr/bin/env python3
import base64
import hashlib
import os
import shutil
import subprocess
import sys
import tempfile
import zipfile


def fold_manifest_line(name, value):
    raw = f"{name}: {value}".encode("utf-8")
    lines = []
    while len(raw) > 70:
        lines.append(raw[:70])
        raw = b" " + raw[70:]
    lines.append(raw)
    return b"\r\n".join(lines) + b"\r\n"


def digest_b64(data):
    return base64.b64encode(hashlib.sha256(data).digest()).decode("ascii")


def run(cmd):
    subprocess.run(cmd, check=True)


def main():
    if len(sys.argv) != 5:
        print("usage: sign-apk-v1.py unsigned.apk signed.apk keystore.p12 alias", file=sys.stderr)
        return 2

    unsigned_apk, signed_apk, keystore, alias = sys.argv[1:]
    storepass = os.environ.get("TCL_POWERMENU_STOREPASS")
    if not storepass:
        print("TCL_POWERMENU_STOREPASS is required", file=sys.stderr)
        return 2

    work = tempfile.mkdtemp(prefix="tcl-power-sign-")
    try:
        cert_pem = os.path.join(work, "cert.pem")
        key_pem = os.path.join(work, "key.pem")
        sf_path = os.path.join(work, "CERT.SF")
        rsa_path = os.path.join(work, "CERT.RSA")

        run([
            "openssl",
            "pkcs12",
            "-in",
            keystore,
            "-passin",
            f"pass:{storepass}",
            "-nokeys",
            "-clcerts",
            "-out",
            cert_pem,
        ])
        run([
            "openssl",
            "pkcs12",
            "-in",
            keystore,
            "-passin",
            f"pass:{storepass}",
            "-nocerts",
            "-nodes",
            "-out",
            key_pem,
        ])

        entries = []
        with zipfile.ZipFile(unsigned_apk, "r") as zin:
            for info in zin.infolist():
                upper = info.filename.upper()
                if info.is_dir() or upper.startswith("META-INF/"):
                    continue
                entries.append((info, zin.read(info.filename)))

        manifest = b"Manifest-Version: 1.0\r\nCreated-By: TCL Power Menu build\r\n\r\n"
        sections = []
        for info, data in entries:
            section = b""
            section += fold_manifest_line("Name", info.filename)
            section += fold_manifest_line("SHA-256-Digest", digest_b64(data))
            section += b"\r\n"
            sections.append(section)
            manifest += section

        sf = b"Signature-Version: 1.0\r\nCreated-By: TCL Power Menu build\r\n"
        sf += fold_manifest_line("SHA-256-Digest-Manifest", digest_b64(manifest))
        sf += b"\r\n"
        for section in sections:
            name_line = section.split(b"\r\n", 1)[0] + b"\r\n"
            sf += name_line
            sf += fold_manifest_line("SHA-256-Digest", digest_b64(section))
            sf += b"\r\n"

        with open(sf_path, "wb") as fh:
            fh.write(sf)

        run([
            "openssl",
            "smime",
            "-sign",
            "-binary",
            "-noattr",
            "-outform",
            "DER",
            "-in",
            sf_path,
            "-signer",
            cert_pem,
            "-inkey",
            key_pem,
            "-out",
            rsa_path,
        ])

        with zipfile.ZipFile(unsigned_apk, "r") as zin, zipfile.ZipFile(signed_apk, "w") as zout:
            zout.writestr("META-INF/MANIFEST.MF", manifest, compress_type=zipfile.ZIP_DEFLATED)
            zout.writestr("META-INF/CERT.SF", sf, compress_type=zipfile.ZIP_DEFLATED)
            with open(rsa_path, "rb") as fh:
                zout.writestr("META-INF/CERT.RSA", fh.read(), compress_type=zipfile.ZIP_DEFLATED)
            for info, data in entries:
                out_info = zipfile.ZipInfo(info.filename, date_time=info.date_time)
                out_info.compress_type = info.compress_type
                out_info.external_attr = info.external_attr
                out_info.comment = info.comment
                out_info.extra = info.extra
                zout.writestr(out_info, data)
    finally:
        shutil.rmtree(work)

    print(f"signed: {signed_apk} using alias {alias}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
