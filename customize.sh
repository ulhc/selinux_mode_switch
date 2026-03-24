#!/system/bin/sh

clear

echo "======================================="
echo "            SELinux 模式切换            "
echo "======================================="
echo ""

if [ "$KSU" != "true" ]; then
  abort "🚫 错误: 本模块仅限 KernelSU, 不支持 Magisk!!"
fi

echo "✅ 环境检测成功"
echo "📱 当前设备: KernelSU v$KSU_VER ($KSU_VER_CODE)"
echo ""
echo "🎉 SELinux 模式切换模块 安装成功！"
echo ""
