.class public Lcom/philphall/tclpowermenu/PowerMenuActivity;
.super Landroid/app/Activity;
.implements Landroid/content/DialogInterface$OnClickListener;
.implements Landroid/content/DialogInterface$OnCancelListener;
.source "PowerMenuActivity.java"

.field private static final TAG:Ljava/lang/String; = "TclPowerMenu"

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V
    return-void
.end method

.method private execRoot(Ljava/lang/String;)V
    .locals 3

    :try_start_0
    const/4 v0, 0x3
    new-array v0, v0, [Ljava/lang/String;
    const/4 v1, 0x0
    const-string v2, "su"
    aput-object v2, v0, v1
    const/4 v1, 0x1
    const-string v2, "-c"
    aput-object v2, v0, v1
    const/4 v1, 0x2
    aput-object p1, v0, v1
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;
    move-result-object v1
    invoke-virtual {v1, v0}, Ljava/lang/Runtime;->exec([Ljava/lang/String;)Ljava/lang/Process;
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0
    return-void

    :catch_0
    move-exception v0
    const-string v1, "TclPowerMenu"
    const-string v2, "root command failed"
    invoke-static {v1, v2, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    return-void
.end method

.method private rebootTv()V
    .locals 1

    invoke-direct {p0}, Lcom/philphall/tclpowermenu/PowerMenuActivity;->screenOff()V
    const-string v0, "sync; sleep 1; svc power reboot userrequested || setprop sys.powerctl reboot,userrequested || reboot"
    invoke-direct {p0, v0}, Lcom/philphall/tclpowermenu/PowerMenuActivity;->execRoot(Ljava/lang/String;)V
    return-void
.end method

.method private screenOff()V
    .locals 3

    :try_start_0
    invoke-static {p0}, Lcom/tcl/tvmanager/TTvFunctionManager;->getInstance(Landroid/content/Context;)Lcom/tcl/tvmanager/TTvFunctionManager;
    move-result-object v0
    const/4 v1, 0x0
    invoke-virtual {v0, v1}, Lcom/tcl/tvmanager/TTvFunctionManager;->setPowerBacklight(Z)V
    new-instance v0, Lcom/tcl/os/system/TWindowManager;
    invoke-direct {v0, p0}, Lcom/tcl/os/system/TWindowManager;-><init>(Landroid/content/Context;)V
    const/4 v1, 0x1
    invoke-virtual {v0, v1}, Lcom/tcl/os/system/TWindowManager;->setAudioOnlyFlag(Z)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0
    goto :goto_tvkit

    :catch_0
    move-exception v0
    const-string v1, "TclPowerMenu"
    const-string v2, "direct screen off failed, using TVKitService fallback"
    invoke-static {v1, v2, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_tvkit
    const-string v0, "service call TVKitService 60 i32 1"
    invoke-direct {p0, v0}, Lcom/philphall/tclpowermenu/PowerMenuActivity;->execRoot(Ljava/lang/String;)V
    return-void
.end method

.method private standbyTv()V
    .locals 1

    const-string v0, "input keyevent 223"
    invoke-direct {p0, v0}, Lcom/philphall/tclpowermenu/PowerMenuActivity;->execRoot(Ljava/lang/String;)V
    return-void
.end method

.method private shutdownTv()V
    .locals 4

    :try_start_0
    const-string v0, "power"
    invoke-virtual {p0, v0}, Lcom/philphall/tclpowermenu/PowerMenuActivity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Landroid/os/PowerManager;
    const/4 v1, 0x0
    const-string v2, "userrequested"
    const/4 v3, 0x0
    invoke-virtual {v0, v1, v2, v3}, Landroid/os/PowerManager;->shutdown(ZLjava/lang/String;Z)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0
    return-void

    :catch_0
    move-exception v0
    const-string v1, "TclPowerMenu"
    const-string v2, "PowerManager.shutdown failed"
    invoke-static {v1, v2, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    const-string v0, "reboot -p"
    invoke-direct {p0, v0}, Lcom/philphall/tclpowermenu/PowerMenuActivity;->execRoot(Ljava/lang/String;)V
    return-void
.end method

.method public onCancel(Landroid/content/DialogInterface;)V
    .locals 0
    invoke-virtual {p0}, Lcom/philphall/tclpowermenu/PowerMenuActivity;->finish()V
    return-void
.end method

.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 1

    if-eqz p2, :cond_standby
    const/4 v0, 0x1
    if-eq p2, v0, :cond_screen
    const/4 v0, 0x2
    if-eq p2, v0, :cond_reboot
    const/4 v0, 0x3
    if-eq p2, v0, :cond_shutdown
    goto :goto_finish

    :cond_standby
    invoke-direct {p0}, Lcom/philphall/tclpowermenu/PowerMenuActivity;->standbyTv()V
    goto :goto_finish

    :cond_screen
    invoke-direct {p0}, Lcom/philphall/tclpowermenu/PowerMenuActivity;->screenOff()V
    goto :goto_finish

    :cond_reboot
    invoke-direct {p0}, Lcom/philphall/tclpowermenu/PowerMenuActivity;->rebootTv()V
    goto :goto_finish

    :cond_shutdown
    invoke-direct {p0}, Lcom/philphall/tclpowermenu/PowerMenuActivity;->shutdownTv()V

    :goto_finish
    invoke-virtual {p0}, Lcom/philphall/tclpowermenu/PowerMenuActivity;->finish()V
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 3

    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V
    const/4 v0, 0x4
    new-array v0, v0, [Ljava/lang/CharSequence;
    const/4 v1, 0x0
    const-string v2, "Veille normale"
    aput-object v2, v0, v1
    const/4 v1, 0x1
    const-string v2, "Ecran off"
    aput-object v2, v0, v1
    const/4 v1, 0x2
    const-string v2, "Redemarrer"
    aput-object v2, v0, v1
    const/4 v1, 0x3
    const-string v2, "Eteindre"
    aput-object v2, v0, v1
    new-instance v1, Landroid/app/AlertDialog$Builder;
    invoke-direct {v1, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V
    const-string v2, "Alimentation"
    invoke-virtual {v1, v2}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;
    move-result-object v1
    invoke-virtual {v1, v0, p0}, Landroid/app/AlertDialog$Builder;->setItems([Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;
    move-result-object v1
    invoke-virtual {v1, p0}, Landroid/app/AlertDialog$Builder;->setOnCancelListener(Landroid/content/DialogInterface$OnCancelListener;)Landroid/app/AlertDialog$Builder;
    move-result-object v1
    invoke-virtual {v1}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;
    return-void
.end method
