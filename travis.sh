#!/bin/bash
# travis.sh script to

SDK_URL="https://developer.garmin.com/downloads/connect-iq/sdks/connectiq-sdk-win-2.3.4.zip"
SDK_FILE="sdk.zip"
SDK_DIR="sdk"

PEM_FILE="/tmp/developer_key.pem"
DER_FILE="/tmp/developer_key.der"

###

wget -O "${SDK_FILE}" "${SDK_URL}"
unzip "${SDK_FILE}" "bin/*" -d "${SDK_DIR}"

openssl genrsa -out "${PEM_FILE}" 4096
openssl pkcs8 -topk8 -inform PEM -outform DER -in "${PEM_FILE}" -out "${DER_FILE}" -nocrypt

export MB_HOME="${SDK_DIR}"
export MB_PRIVATE_KEY="${DER_FILE}"

# mb_runner needs to know where the resource folder is.
#./mb_runner/mb_runner.sh test `pwd` source/connectiq-PowerField/resources

#
# from mb_runner
#

PROJECT_HOME="${PWD}"
RESOURCES_FOLDER="resources"
SOURCE_FOLDER="source"

#CONFIG_FILE="${PROJECT_HOME}/mb_runner.cfg"
APP_NAME="PowerFieldTests"
TARGET_DEVICES="edge_1000 edge_1030 edge820"
TARGET_SDK_VERSION="2.3.0"

MANIFEST_FILE="${PROJECT_HOME}/manifest.xml"


RESOURCES="`cd /; find \"${PROJECT_HOME}/${RESOURCES_FOLDER}\"* -iname '*.xml' | tr '\n' ':'`"
#SOURCES="`cd /; find \"${PROJECT_HOME}/${SOURCE_FOLDER}\" -iname '*.mc' | tr '\n' ' '`"
#SOURCES=`ls -1 ${PROJECT_HOME}/${SOURCE_FOLDER}/*.mc ${PROJECT_HOME}/${SOURCE_FOLDER}/Mocks/*.mc ${PROJECT_HOME}/${SOURCE_FOLDER}/connectiq-PowerField/source/*.mc | grep -v PowerFieldApp.mc`
SOURCES=`ls -1 ${PROJECT_HOME}/${SOURCE_FOLDER}/*.mc`

API_DB="${MB_HOME}/bin/api.db"
PROJECT_INFO="${MB_HOME}/bin/projectInfo.xml"
API_DEBUG="${MB_HOME}/bin/api.debug.xml"
DEVICES="${MB_HOME}/bin/devices.xml"

# **********
# processing
# **********

# prepare sdk executables and apply "wine-ification", if not already done so ...

if [ ! -e "${MB_HOME}/bin/monkeydo.bak" ] ; then
    cp -a "${MB_HOME}/bin/monkeydo" "${MB_HOME}/bin/monkeydo.bak"
    dos2unix "${MB_HOME}/bin/monkeydo"
    chmod +x "${MB_HOME}/bin/monkeydo"
    sed -i -e 's/"\$MB_HOME"\/shell/wine "\$MB_HOME"\/shell.exe/g' "${MB_HOME}/bin/monkeydo"
fi

if [ ! -e "${MB_HOME}/bin/monkeyc.bak" ] ; then
    cp -a "${MB_HOME}/bin/monkeyc" "${MB_HOME}/bin/monkeyc.bak"
    chmod +x "${MB_HOME}/bin/monkeyc"
    dos2unix "${MB_HOME}/bin/monkeyc"
fi

if [ ! -e "${MB_HOME}/bin/connectiq.bak" ] ; then
    cp -a "${MB_HOME}/bin/connectiq" "${MB_HOME}/bin/connectiq.bak"
    chmod +x "${MB_HOME}/bin/connectiq"
    dos2unix "${MB_HOME}/bin/connectiq"
fi

chmod +x ${MB_HOME}/bin/*.exe
chmod +x ${MB_HOME}/bin/monkeyc
chmod +x ${MB_HOME}/bin/connectiq
ls -al ${MB_HOME}/bin

# start X virtual framebuffer
which Xvfb
Xvfb :0 -screen 0 1024x768x16 &
export DISPLAY=:0.0

function concat_params_for_build
{
    PARAMS+="--apidb \"${API_DB}\" "
    PARAMS+="--device \"${TARGET_DEVICE}\" "
    PARAMS+="--import-dbg \"${API_DEBUG}\" "
    PARAMS+="--manifest \"${MANIFEST_FILE}\" "
    PARAMS+="--output \"${APP_NAME}.prg\" "
    PARAMS+="--project-info \"${PROJECT_INFO}\" "
    PARAMS+="--sdk-version \"${TARGET_SDK_VERSION}\" "
    PARAMS+="--unit-test "
    PARAMS+="--devices \"${DEVICES}\" "
    PARAMS+="--warn "
    PARAMS+="--private-key \"${MB_PRIVATE_KEY}\" "
    PARAMS+="--rez \"${RESOURCES}\" "
}

function concat_params_for_package
{
    PARAMS+="--package-app "
    PARAMS+="--manifest \"${MANIFEST_FILE}\" "
    PARAMS+="--output \"${APP_NAME}.iq\" "
    PARAMS+="--release "
    PARAMS+="--warn "
    PARAMS+="--private-key \"${MB_PRIVATE_KEY}\" "
    PARAMS+="--rez \"${RESOURCES}\" "
}

function start_simulator
{
    SIM_PID=$(ps aux | grep simulator.exe | grep -v "grep" | awk '{print $2}')

    if [[ ${SIM_PID} ]]; then
		echo "Killing simulator PID=${SIM_PID}"
        kill ${SIM_PID}
    fi

	echo "Starting simulator"
	echo "wine ${MB_HOME}/bin/simulator.exe"
	echo "display=${DISPLAY}"
	wine ${MB_HOME}/bin/simulator.exe /nogui &
}

function run_mb_jar
{
	echo "java -Dfile.encoding=UTF-8 -Dapple.awt.UIElement=true  -jar \"${MB_HOME}/bin/monkeybrains.jar\" ${PARAMS} ${SOURCES}"
    java -Dfile.encoding=UTF-8 -Dapple.awt.UIElement=true  -jar "${MB_HOME}/bin/monkeybrains.jar" ${PARAMS} ${SOURCES}
}

function run_tests
{
	echo "\"${MB_HOME}/bin/monkeydo\" \"${PROJECT_HOME}/${APP_NAME}.prg\" ${TARGET_DEVICE} -t"
    "${MB_HOME}/bin/monkeydo" "${PROJECT_HOME}/${APP_NAME}.prg" ${TARGET_DEVICE} -t
}

cd ${PROJECT_HOME}
for TARGET_DEVICE in ${TARGET_DEVICES}
do
	echo "Target Device: ${TARGET_DEVICE}"
	#start_simulator
	#sleep 2
	PARAMS=""
    concat_params_for_package
	#concat_params_for_build
	run_mb_jar
	#ps -ef | grep simulator
	#run_tests
	echo "=============="
	#sleep 2
done

