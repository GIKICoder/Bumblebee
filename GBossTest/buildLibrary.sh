#!/bin/sh
export LC_COLLATE='C'
export LC_CTYPE='C'
export LC_CTYPE=en_US.UTF-8

#统一fail处理函数
Failed()
{
    echo "Failed: $*"
    exit -1
}

root_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#src_path="FSComCore"


xcodePath=/usr/bin
sdkDevice="iphoneos10.2"
sdkSimulator="iphonesimulator10.2"
configuration_array=("Release" "Debug")
arch_array=("iphoneos" "iphonesimulator")
arch_device_array=("armv7" "arm64")
arch_iphonesimulator_array=("i386" "x86_64")

project_name="GBossTest.xcodeproj"
runTarget='GBossTest'
iphone_com_path="${root_path}/../Library/GBossTest"

#删除之前的产出
rm -fr $root_path/scm-output/*
mkdir scm-output

echo $iphone_com_path

echo "Build and Archive Run Target..."

for arch in ${arch_array[*]}; do
    for configuration in ${configuration_array[*]} ; do
        if [ ${arch} = "iphoneos" ]; then
            sdk=$sdkDevice
            arch_type_array=${arch_device_array[*]}
        elif [ ${arch} = "iphonesimulator" ]; then
            if [ ${configuration} = "Release" ]; then
                continue
            fi
            sdk=$sdkSimulator
            arch_type_array=${arch_iphonesimulator_array[*]}
        fi

        for arch_type in ${arch_type_array[*]}; do
            build_output_dir="$root_path/scm-output/${configuration}-${arch}/${arch_type}"

            echo "build_output_dir: $build_output_dir"
            echo "sdk: $sdk"
            echo "arch: $arch_type"

            #cd $root_path/$src_path

            cd $root_path

            #clean
            echo "${xcodePath}/xcodebuild" -target "$runTarget" -configuration "$configuration" -sdk "$sdk" clean || Failed "Clean Run Target"
            "${xcodePath}/xcodebuild" -target "$runTarget" -configuration "$configuration" -sdk "$sdk" clean || Failed "Clean Run Target"

            #build
            echo "${xcodePath}/xcodebuild" -project "$project_name"  -target "$runTarget" -configuration "$configuration" -sdk "$sdk" -arch "$arch_type" CONFIGURATION_BUILD_DIR=${build_output_dir}  || Failed "Build Run Target"
            "${xcodePath}/xcodebuild" -project "$project_name"  -target "$runTarget" -configuration "$configuration" -sdk "$sdk" -arch "$arch_type" CONFIGURATION_BUILD_DIR=${build_output_dir}  || Failed "Build Run Target"
        done
        
        lipo_dic="$root_path/scm-output/${configuration}-${arch}"
        cd "${lipo_dic}"
        find . -name "lib${runTarget}.a" | xargs lipo -output "${lipo_dic}/lib${runTarget}.a" -create
        find . -type d | grep '^\./' | xargs rm -rf
    done
done

echo "Build and Archive Run Target end"

rm -fr $iphone_com_path/*
cp -r $root_path/inc $iphone_com_path
cp -r $root_path/scm-output/* $iphone_com_path
rm -fr $root_path/build
rm -rf $root_path/scm-output

echo 'build and install success'
