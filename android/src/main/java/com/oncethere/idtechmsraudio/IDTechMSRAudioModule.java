//
//  IDTECH_MSR_audio
//
//  Created by Peace Chen on 2/27/2018.
//  Copyright © 2018 OnceThere. All rights reserved.
//

package com.oncethere.idtechmsraudio;

import IDTech.MSR.XMLManager.StructConfigParameters;
import IDTech.MSR.uniMag.Common;
import IDTech.MSR.uniMag.StateList;
import IDTech.MSR.uniMag.uniMagReader;
import IDTech.MSR.uniMag.uniMagReaderMsg;
import IDTech.MSR.uniMag.UniMagTools.uniMagReaderToolsMsg;
import IDTech.MSR.uniMag.UniMagTools.uniMagSDKTools;
import IDTech.MSR.uniMag.uniMagReader.ReaderType;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.util.HashMap;
import java.util.Map;
import javax.annotation.Nullable;

public class IDTechMSRAudioModule extends ReactContextBaseJavaModule implements uniMagReaderMsg {

  private uniMagReader _uniMagReader = null;
  private ReactApplicationContext _reactContext = null;
  private AutoConfigProfile autoConfigProfile = new AutoConfigProfile();


  public IDTechMSRAudioModule(ReactApplicationContext reactContext) {
    super(reactContext);
    _reactContext = reactContext;
  }

  @Override
  public String getName() {
    return "IDTECH_MSR_audio";
  }

  @ReactMethod
  public void activate(Integer readerType, Integer swipeTimeout, Boolean logging, Promise promise) {
    Integer statusCode = UmRet.UMRET_SUCCESS.getValue();
    String message = "";

    if (_uniMagReader!=null) {
			_uniMagReader.unregisterListen();
			_uniMagReader.release();
			_uniMagReader = null;
		}

    ReaderType _readerType;
    UmReader umReaderType = UmReader.valueOf(readerType);
    switch (umReaderType)	{
      case UMREADER_UNIMAG_ORIGINAL:
        _readerType = ReaderType.UM;
        break;
      case UMREADER_UNIMAG_PRO:
        _readerType = ReaderType.UM_PRO;
        break;
      case UMREADER_UNIMAG_II:
        _readerType = ReaderType.UM_II;
        break;
      case UMREADER_SHUTTLE:
      default:
        _readerType = ReaderType.SHUTTLE;
        break;
    }

		_uniMagReader = new uniMagReader(this, _reactContext, _readerType);

		if (_uniMagReader != null) {
      _uniMagReader.registerListen();
      _uniMagReader.setTimeoutOfSwipeCard(swipeTimeout == 0 ? Integer.MAX_VALUE : swipeTimeout);
      _uniMagReader.setVerboseLoggingEnable(logging);

      StructConfigParameters acProfile = autoConfigProfile.loadAutoConfigProfile(_reactContext);

      if (acProfile != null) {
        sendEvent("IdTechUniMagEvent", autoConfigProfile.toWritableMap(acProfile));
        _uniMagReader.connectWithProfile(acProfile);
        message = "Found existing auto config profile.";
      }
      else {
        message = "Starting auto config.";
        _uniMagReader.startAutoConfig(true);

        // ID Tech's device profile table is too limited for production use.
        // _uniMagReader.setXMLFileNameWithPath("/sdcard/IDT_uniMagCfg.xml");
        // if (_uniMagReader.loadingConfigurationXMLFile(true)) {
        //   message = "Found existing config file.";
        //   _uniMagReader.connect();
        // }
      }
    }
    else {
      statusCode = UmRet.UMRET_NO_READER.getValue();
      message = "Failed to initialize UniMag";
    }

    WritableMap result = Arguments.createMap();
    result.putInt("statusCode", statusCode);
    result.putString("message", message);
    promise.resolve(result);
  }

  @ReactMethod
  public void deactivate(Promise promise) {
    if (_uniMagReader != null) {
      _uniMagReader.stopSwipeCard();
      _uniMagReader.unregisterListen();
      _uniMagReader.release();
		}

    WritableMap result = Arguments.createMap();
    result.putInt("statusCode", UmRet.UMRET_SUCCESS.getValue());
    result.putString("message", "");
    promise.resolve(result);
  }

  @ReactMethod
  public void swipe(Promise promise) {
    Integer statusCode = UmRet.UMRET_SUCCESS.getValue();
    String message = "Starting swipe...";

    if (_uniMagReader != null) {
      if (_uniMagReader.startSwipeCard()) {

      }
    }
    else {
      statusCode = UmRet.UMRET_NO_READER.getValue();
      message = "Unable to start swipe.";
    }

    WritableMap result = Arguments.createMap();
    result.putInt("statusCode", statusCode);
    result.putString("message", message);
    promise.resolve(result);
  }


  // ---------------------------------------------------------------------------
  // Helper methods
  private void sendEvent(String eventName,
                         @Nullable WritableMap params) {
    _reactContext
        .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
        .emit(eventName, params);
  }

  // ---------------------------------------------------------------------------
  // Required callbacks for uniMagReaderMsg
  public void onReceiveMsgToConnect() {
    WritableMap result = Arguments.createMap();
    result.putString("type", "umConnection_starting");
    result.putString("message", "Starting connection with reader.");
    sendEvent("IdTechUniMagEvent", result);
  }

  public void onReceiveMsgConnected() {
    WritableMap result = Arguments.createMap();
    result.putString("type", "umConnection_connected");
    result.putString("message", "Reader successfully connected.");
    sendEvent("IdTechUniMagEvent", result);
  }

  public void onReceiveMsgDisconnected() {
    WritableMap result = Arguments.createMap();
    result.putString("type", "umConnection_disconnected");
    result.putString("message", "Reader has been disconnected.");
    sendEvent("IdTechUniMagEvent", result);
  }

  public void onReceiveMsgTimeout(String strTimeoutMsg) {
    WritableMap result = Arguments.createMap();
    result.putString("type", "umConnection_timeout");
    result.putString("message", "Connecting with reader timed out. Please try again.");
    sendEvent("IdTechUniMagEvent", result);
  }

  public void onReceiveMsgToSwipeCard() {
    WritableMap result = Arguments.createMap();
    result.putString("type", "umSwipe_starting");
    result.putString("message", "Waiting for card swipe...");
    sendEvent("IdTechUniMagEvent", result);
  }

  public void onReceiveMsgCardData(byte flagOfCardData, byte[] cardData) {
    WritableArray cardDataArray = Arguments.createArray();
    cardDataArray.pushString(new String(cardData, java.nio.charset.StandardCharsets.ISO_8859_1));
    WritableMap data = Arguments.createMap();
    data.putBoolean("isValid", true);
    data.putBoolean("isAesEncrypted", (flagOfCardData & (1L << 1)) != 0 && (flagOfCardData & (1L << 2)) != 0);
    data.putArray("tracks", cardDataArray);

    WritableMap result = Arguments.createMap();
    result.putString("type", "umSwipe_receivedSwipe");
    result.putString("message", "Successful card swipe");
    result.putInt("flagOfCardData", flagOfCardData);
    result.putMap("data", data);
    sendEvent("IdTechUniMagEvent", result);
  }

  public void onReceiveMsgProcessingCardData() {
    WritableMap result = Arguments.createMap();
    result.putString("type", "umSwipe_processing_card_data");
    result.putString("message", "");
    sendEvent("IdTechUniMagEvent", result);
  }

  public void onReceiveMsgToCalibrateReader() {
    WritableMap result = Arguments.createMap();
    result.putString("type", "umSwipe_calibrate_card_reader");
    result.putString("message", "");
    sendEvent("IdTechUniMagEvent", result);
  }

  public void onReceiveMsgCommandResult(int commandID, byte[] cmdReturn) {
    WritableMap result = Arguments.createMap();
    result.putString("type", "umCommand_result");
    result.putString("message", Integer.toString(commandID));
    result.putString("result", new String(cmdReturn, java.nio.charset.StandardCharsets.ISO_8859_1));
    sendEvent("IdTechUniMagEvent", result);
  }

  @Deprecated
  public void onReceiveMsgSDCardDFailed(String strMSRData) {
    WritableMap result = Arguments.createMap();
    result.putString("type", "umSD_card_failed");
    result.putString("message", strMSRData);
    sendEvent("IdTechUniMagEvent", result);
  }

  public void onReceiveMsgFailureInfo(int index , String strMessage) {
    WritableMap result = Arguments.createMap();
    result.putString("type", "umFail");
    result.putString("message", strMessage);
    result.putInt("index", index);
    sendEvent("IdTechUniMagEvent", result);
  }

  public void onReceiveMsgAutoConfigProgress(int progressValue) {
    WritableMap result = Arguments.createMap();
    result.putString("type", "umAutoconfig_progress");
    result.putString("message", Integer.toString(progressValue));
    sendEvent("IdTechUniMagEvent", result);
  }

  public void onReceiveMsgAutoConfigProgress(int percent, double res, String profileName) {
    WritableMap result = Arguments.createMap();
    result.putString("type", "umAutoconfig_progress");
    result.putString("message", Integer.toString(percent));
    result.putDouble("result", res);
    result.putString("profileName", profileName);
    sendEvent("IdTechUniMagEvent", result);
  }

  public void onReceiveMsgAutoConfigCompleted(StructConfigParameters profile) {
    if (!autoConfigProfile.saveAutoConfigProfile(profile, _reactContext)) {
      WritableMap saveResult = Arguments.createMap();
      saveResult.putString("type", "umAutoconfig_save_failed");
      saveResult.putString("message", "Failed to save auto config profile.");
      sendEvent("IdTechUniMagEvent", saveResult);
    }

    sendEvent("IdTechUniMagEvent", autoConfigProfile.toWritableMap(profile));
    WritableMap result = Arguments.createMap();
    result.putString("type", "umAutoconfig_complete");
    result.putString("message", "Completed autoconfig. Connecting to reader.");
    sendEvent("IdTechUniMagEvent", result);
    _uniMagReader.connectWithProfile(profile);
  }

  public boolean getUserGrant(int type, String strMessage) {
    boolean getUserGranted = false;
		switch(type) {
  		case uniMagReaderMsg.typeToPowerupUniMag:
  		case uniMagReaderMsg.typeToUpdateXML:
  		case uniMagReaderMsg.typeToOverwriteXML:
  		case uniMagReaderMsg.typeToReportToIdtech:
  			getUserGranted = true;
  			break;
		}

    WritableMap result = Arguments.createMap();
    result.putString("type", "umUser_grant");
    result.putString("message", strMessage);
    result.putInt("result", type);
    sendEvent("IdTechUniMagEvent", result);

		return getUserGranted;
  }

}
