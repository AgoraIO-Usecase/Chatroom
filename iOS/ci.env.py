#!/usr/bin/python
# -*- coding: UTF-8 -*-
import re
import os
import shutil

TARGET_LIBS_ZIP = "agora_sdk.zip"
TARGET_INTERNAL_FOLDER = "agora_sdk"


def main():
    RTC_SDK_URL = ""
    if "RTC_SDK_URL" in os.environ:
        RTC_SDK_URL = os.environ["RTC_SDK_URL"]

    RTM_SDK_URL = ""
    if "RTM_SDK_URL" in os.environ:
        RTM_SDK_URL = os.environ["RTM_SDK_URL"]

    SCHEME = ""
    if "SCHEME" in os.environ:
        SCHEME = os.environ["SCHEME"]

    downloadSDK(RTC_SDK_URL)
    downloadSDK(RTM_SDK_URL)

    if not os.path.exists(SCHEME + "/libs"):
        os.mkdir(SCHEME + "/libs")

    mv = "cp -f -r " + TARGET_INTERNAL_FOLDER + "/*/libs/* " + SCHEME + "/libs"
    os.system(mv)

    os.remove(TARGET_LIBS_ZIP)
    shutil.rmtree(TARGET_INTERNAL_FOLDER, ignore_errors=True)

    appId = ""
    if "AGORA_APP_ID" in os.environ:
        appId = os.environ["AGORA_APP_ID"]
    token = ""

    # if need reset
    f = open("./" + SCHEME + "/Constant.swift", 'r+')
    content = f.read()

    # if need reset
    agoraAppString = "\"" + appId + "\""
    agoraTokenString = "\"" + token + "\""
    contentNew = re.sub(r'<#Your App Id#>', agoraAppString, content)
    contentNew = re.sub(r'<#Temp Access Token#>', agoraTokenString, contentNew)
    contentNew = re.sub(r'<#Temp Rtm Access Token#>', agoraTokenString, contentNew)

    f.seek(0)
    f.write(contentNew)
    f.truncate()


def downloadSDK(url):
    wget = "wget " + url + " -O " + TARGET_LIBS_ZIP
    os.system(wget)

    unzip = "unzip " + TARGET_LIBS_ZIP + " \"*/libs/*\" -d " + TARGET_INTERNAL_FOLDER
    os.system(unzip)


if __name__ == "__main__":
    main()
