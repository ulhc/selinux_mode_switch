#!/system/bin/sh

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

TIMEOUT_SECONDS=10
while [ $TIMEOUT_SECONDS -gt 0 ]; do
    clear
    echo "======================================="
    echo "            SELinux 模式切换            "
    echo "======================================="
    echo "- 请按键选择: "
    echo "- [🔼 音量上键]: 🔒 强制模式(Enforcing)"
    echo "- [🔽 音量下键]: 🔓 宽容模式(Permissive)"
    echo "- [⏺️ 电源键  ]: 🤡 取消操作(Exit)"
    echo "======================================="
    echo ""
    echo "🎉 当前 SELinux 状态: $SELINUX_MODE_DESC"
    echo ""
    echo "⏳ 请按下指定按键, 否则将在 $TIMEOUT_SECONDS 秒后取消本次操作. . ."

    KEY_EVENT=$(timeout 1 getevent -lc 1 2>&1)
    if echo "$KEY_EVENT" | grep -q "KEY_VOLUMEUP"; then
        echo "您按下了 [🔼 音量上键]: 🔒 强制模式(Enforcing). . ."
        if [ "$STATUS" != "Enforcing" ]; then
            setenforce 1
        fi
        break
    elif echo "$KEY_EVENT" | grep -q "KEY_VOLUMEDOWN"; then
        echo "您按下了 [🔽 音量下键]: 🔓 宽容模式(Permissive). . ."
        if [ "$STATUS" != "Permissive" ]; then
            setenforce 0
        fi
        break
    elif echo "$KEY_EVENT" | grep -q "KEY_POWER"; then
        echo "您按下了 [⏺️ 电源键  ]: 🤡 取消操作(Exit). . ."
        break
    fi

    TIMEOUT_SECONDS=$((TIMEOUT_SECONDS - 1))
done
if [ $TIMEOUT_SECONDS -eq 0 ]; then
    echo "⏰ 操作超时, 已自动取消!"
fi
echo ""

exit 0