.class public Lcom/philphall/tclpowermenu/PowerAccessibilityService;
.super Landroid/accessibilityservice/AccessibilityService;
.source "PowerAccessibilityService.java"

.field private static final TAG:Ljava/lang/String; = "TclPowerMenu"

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroid/accessibilityservice/AccessibilityService;-><init>()V
    return-void
.end method

.method private execRoot(Ljava/lang/String;)V
    .locals 5

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
    const-string v2, "root fallback failed"
    invoke-static {v1, v2, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    return-void
.end method

.method private isBacklightOff()Z
    .locals 3

    :try_start_0
    new-instance v0, Lcom/tcl/os/system/TWindowManager;
    invoke-direct {v0, p0}, Lcom/tcl/os/system/TWindowManager;-><init>(Landroid/content/Context;)V
    invoke-virtual {v0}, Lcom/tcl/os/system/TWindowManager;->getAudioOnlyFlag()Z
    move-result v0
    if-eqz v0, :try_start_1
    const/4 v0, 0x1
    return v0
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    move-exception v0
    const-string v1, "TclPowerMenu"
    const-string v2, "AudioOnly state unavailable"
    invoke-static {v1, v2, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :try_start_1
    invoke-static {p0}, Lcom/tcl/tvmanager/TTvFunctionManager;->getInstance(Landroid/content/Context;)Lcom/tcl/tvmanager/TTvFunctionManager;
    move-result-object v0
    invoke-virtual {v0}, Lcom/tcl/tvmanager/TTvFunctionManager;->getPowerBacklightSate()Z
    move-result v0
    if-nez v0, :cond_on
    const/4 v0, 0x1
    return v0
    :try_end_1
    .catch Ljava/lang/Throwable; {:try_start_1 .. :try_end_1} :catch_1

    :catch_1
    move-exception v0
    const-string v1, "TclPowerMenu"
    const-string v2, "Backlight state unavailable"
    invoke-static {v1, v2, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_on
    const/4 v0, 0x0
    return v0
.end method

.method private static isHandledKey(I)Z
    .locals 1

    const/16 v0, 0x1a
    if-eq p0, v0, :cond_yes
    const/16 v0, 0x8c
    if-eq p0, v0, :cond_yes
    const/16 v0, 0x8d
    if-eq p0, v0, :cond_yes
    const/16 v0, 0x1a8
    if-eq p0, v0, :cond_yes
    const/16 v0, 0x119e
    if-eq p0, v0, :cond_yes
    const/16 v0, 0x119f
    if-eq p0, v0, :cond_yes
    const/4 v0, 0x0
    return v0

    :cond_yes
    const/4 v0, 0x1
    return v0
.end method

.method private showPowerMenu()V
    .locals 3

    :try_start_0
    new-instance v0, Landroid/content/Intent;
    const-class v1, Lcom/philphall/tclpowermenu/PowerMenuActivity;
    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    const/high16 v1, 0x10000000
    invoke-virtual {v0, v1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;
    move-result-object v0
    const/high16 v1, 0x4000000
    invoke-virtual {v0, v1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;
    move-result-object v0
    invoke-virtual {p0, v0}, Lcom/philphall/tclpowermenu/PowerAccessibilityService;->startActivity(Landroid/content/Intent;)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception v0
    const-string v1, "TclPowerMenu"
    const-string v2, "show menu failed"
    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    return-void
.end method

.method private wakeBacklight()V
    .locals 3

    :try_start_0
    new-instance v0, Lcom/tcl/os/system/TWindowManager;
    invoke-direct {v0, p0}, Lcom/tcl/os/system/TWindowManager;-><init>(Landroid/content/Context;)V
    const/4 v1, 0x0
    invoke-virtual {v0, v1}, Lcom/tcl/os/system/TWindowManager;->setAudioOnlyFlag(Z)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_backlight

    :catch_0
    move-exception v0
    const-string v1, "TclPowerMenu"
    const-string v2, "setAudioOnlyFlag(false) failed"
    invoke-static {v1, v2, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_backlight
    :try_start_1
    invoke-static {p0}, Lcom/tcl/tvmanager/TTvFunctionManager;->getInstance(Landroid/content/Context;)Lcom/tcl/tvmanager/TTvFunctionManager;
    move-result-object v0
    const/4 v1, 0x1
    invoke-virtual {v0, v1}, Lcom/tcl/tvmanager/TTvFunctionManager;->setPowerBacklight(Z)V
    :try_end_1
    .catch Ljava/lang/Throwable; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_done

    :catch_1
    move-exception v0
    const-string v1, "TclPowerMenu"
    const-string v2, "setPowerBacklight(true) failed"
    invoke-static {v1, v2, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    const-string v0, "service call TVKitService 60 i32 0; input keyevent 224; input keyevent 4510"
    invoke-direct {p0, v0}, Lcom/philphall/tclpowermenu/PowerAccessibilityService;->execRoot(Ljava/lang/String;)V

    :goto_done
    const-string v0, "TclPowerMenu"
    const-string v1, "wake backlight requested"
    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    return-void
.end method

.method public onAccessibilityEvent(Landroid/view/accessibility/AccessibilityEvent;)V
    .locals 0
    return-void
.end method

.method public onInterrupt()V
    .locals 0
    return-void
.end method

.method public onKeyEvent(Landroid/view/KeyEvent;)Z
    .locals 5

    if-nez p1, :cond_event
    const/4 v0, 0x0
    return v0

    :cond_event
    invoke-virtual {p1}, Landroid/view/KeyEvent;->getKeyCode()I
    move-result v0
    invoke-static {v0}, Lcom/philphall/tclpowermenu/PowerAccessibilityService;->isHandledKey(I)Z
    move-result v1
    if-nez v1, :cond_handled
    const/4 v0, 0x0
    return v0

    :cond_handled
    invoke-virtual {p1}, Landroid/view/KeyEvent;->getAction()I
    move-result v2
    if-eqz v2, :cond_consume
    const/4 v3, 0x1
    if-ne v2, v3, :cond_consume
    invoke-direct {p0}, Lcom/philphall/tclpowermenu/PowerAccessibilityService;->showPowerMenu()V
    return v3

    :cond_consume
    const/4 v0, 0x1
    return v0
.end method

.method protected onServiceConnected()V
    .locals 2

    invoke-super {p0}, Landroid/accessibilityservice/AccessibilityService;->onServiceConnected()V
    const-string v0, "TclPowerMenu"
    const-string v1, "accessibility service connected"
    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    return-void
.end method
