#!/system/bin/sh
START_TIME=$(date +%s)
TIMEOUT_SECONDS=10
while true; do
    SELINUX_MODE=$(getenforce)
    if [ "$SELINUX_MODE" = "Disabled" ]; then
        SELINUX_MODE_DESC="🚫 已禁用"
    elif [ "$SELINUX_MODE" = "Enforcing" ]; then
        SELINUX_MODE_DESC="🔒 强制模式"
    elif [ "$SELINUX_MODE" = "Permissive" ]; then
        SELINUX_MODE_DESC="🔓 宽容模式"
    else
        SELINUX_MODE_DESC="❓ 未知($SELINUX_MODE)"
    fi
    clear
    echo "======================================"
    echo "         🔥SELinux 模式切换🔥         "
    echo "======================================"
    echo "- 请按键选择: "
    echo "- [🔼 音量上键]: 🔒 强制模式(Enforcing)"
    echo "- [🔽 音量下键]: 🔓 宽容模式(Permissive)"
    echo "- [⏺️ 电源键  ]: 🤡 取消操作(Exit)"
    echo "======================================="
    echo ""
    echo "🎉 当前 SELinux 状态: $SELINUX_MODE_DESC"
    echo ""
    NOW_TIME=$(date +%s)
    ELAPSED=$((NOW_TIME - START_TIME))
    LEFT_SECONDS=$((TIMEOUT_SECONDS - ELAPSED))
    echo "⏳ 将在 $LEFT_SECONDS 秒后取消本次操作, 请按下指定按键 . . ."
    echo ""
    KEY_EVENT=$(timeout 1 getevent -lc 1 2>&1 | grep KEY_)
    if [ $ELAPSED -ge $TIMEOUT_SECONDS ]; then
        echo "⏰ 等待按键超时, 已为您自动取消本次操作!"
        break
    elif echo "$KEY_EVENT" | grep -q "KEY_VOLUMEUP"; then
        echo "🔒 已切换为: 强制模式(Enforcing). . ."
        setenforce 1
        break
    elif echo "$KEY_EVENT" | grep -q "KEY_VOLUMEDOWN"; then
        echo "🔓 已切换为: 宽容模式(Permissive). . ."
        setenforce 0
        break
    elif echo "$KEY_EVENT" | grep -q "KEY_POWER"; then
        echo "🤡 您选择了取消本次操作. . ."
        break
    fi
done
echo ""
sleep 0.5
exit 0