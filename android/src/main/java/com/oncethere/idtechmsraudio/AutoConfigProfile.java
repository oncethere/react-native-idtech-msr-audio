//
//  Serializable AutoConfigProfile 'struct' to handle non-serializable StructConfigParameters
//
//  Created by Peace Chen on 4/2/2018.
//  Copyright © 2018 OnceThere. All rights reserved.
//

package com.oncethere.idtechmsraudio;

import IDTech.MSR.XMLManager.StructConfigParameters;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.Arguments;

import java.io.Serializable;
import android.content.Context;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.io.ObjectInputStream;
import java.io.FileOutputStream;
import java.io.FileInputStream;


public class AutoConfigProfile implements Serializable {
  static final String AUTO_CONFIG_FILENAME = "umAutoConfigProfile";

  public short DirectionOutputWave;
  public int   FrequencyInput;
  public int   FrequencyOutput;
  public int   RecordBufferSize;
  public int   RecordReadBufferSize;
  public int   WaveDirection;
  public short HighThreshold;
  public short LowThreshold;
  public short Min;
  public short Max;
  public int   BaudRate;
  public short PreambleFactor;
  public byte  ShuttleChannel;
  public short ForceHeadsetPlug;
  public short UseVoiceRecognition;
  public short VolumeLevelAdjust;

  // Serializes auto config object and saves it to a file
  public boolean saveAutoConfigProfile(StructConfigParameters profile, ReactApplicationContext ctx) {
    DirectionOutputWave = profile.getDirectionOutputWave();
    FrequencyInput = profile.getFrequenceInput();
    FrequencyOutput = profile.getFrequenceOutput();
    RecordBufferSize = profile.getRecordBufferSize();
    RecordReadBufferSize = profile.getRecordReadBufferSize();
    WaveDirection = profile.getWaveDirection();
    HighThreshold = profile.gethighThreshold();
    LowThreshold = profile.getlowThreshold();
    Min = profile.getMin();
    Max = profile.getMax();
    BaudRate = profile.getBaudRate();
    PreambleFactor = profile.getPreAmbleFactor();
    ShuttleChannel = profile.getShuttleChannel();
    ForceHeadsetPlug = profile.getForceHeadsetPlug();
    UseVoiceRecognition = profile.getUseVoiceRecognition();
    VolumeLevelAdjust = profile.getVolumeLevelAdjust();

    try {
        FileOutputStream fileOutputStream = ctx.openFileOutput(AUTO_CONFIG_FILENAME, Context.MODE_PRIVATE);
        ObjectOutputStream objectOutputStream = new ObjectOutputStream(fileOutputStream);
        objectOutputStream.writeObject(this);
        objectOutputStream.close();
        fileOutputStream.close();
    } catch (IOException e) {
        e.printStackTrace();
        return false;
    }

    return true;
  }

  // Creates an object by reading it from a file
  public StructConfigParameters loadAutoConfigProfile(ReactApplicationContext ctx) {
    try {
        FileInputStream fileInputStream = ctx.openFileInput(AUTO_CONFIG_FILENAME);
        ObjectInputStream objectInputStream = new ObjectInputStream(fileInputStream);
        AutoConfigProfile autoConfig = (AutoConfigProfile) objectInputStream.readObject();
        objectInputStream.close();
        fileInputStream.close();

        StructConfigParameters profile = new StructConfigParameters();
        profile.setDirectionOutputWave(autoConfig.DirectionOutputWave);
        profile.setFrequenceInput(autoConfig.FrequencyInput);
        profile.setFrequenceOutput(autoConfig.FrequencyOutput);
        profile.setRecordBufferSize(autoConfig.RecordBufferSize);
        profile.setRecordReadBufferSize(autoConfig.RecordReadBufferSize);
        profile.setWaveDirection(autoConfig.WaveDirection);
        profile.sethighThreshold(autoConfig.HighThreshold);
        profile.setlowThreshold(autoConfig.LowThreshold);
        profile.setMin(autoConfig.Min);
        profile.setMax(autoConfig.Max);
        profile.setBaudRate(autoConfig.BaudRate);
        profile.setPreAmbleFactor(autoConfig.PreambleFactor);
        profile.setShuttleChannel(autoConfig.ShuttleChannel);
        profile.setForceHeadsetPlug(autoConfig.ForceHeadsetPlug);
        profile.setUseVoiceRecognition(autoConfig.UseVoiceRecognition);
        profile.setVolumeLevelAdjust(autoConfig.VolumeLevelAdjust);
        return profile;
    } catch (IOException e) {
        e.printStackTrace();
    }
    catch (ClassNotFoundException e) {
        e.printStackTrace();
    }

    return null;
  }

  public WritableMap toWritableMap(StructConfigParameters profile) {
    WritableMap result = Arguments.createMap();
    result.putString("type", "umAutoConfigProfile");
    result.putString("message", "auto config profile");

    result.putInt("DirectionOutputWave", profile.getDirectionOutputWave());
    result.putInt("FrequencyInput", profile.getFrequenceInput());
    result.putInt("FrequencyOutput", profile.getFrequenceOutput());
    result.putInt("RecordBufferSize", profile.getRecordBufferSize());
    result.putInt("RecordReadBufferSize", profile.getRecordReadBufferSize());
    result.putInt("WaveDirection", profile.getWaveDirection());
    result.putInt("HighThreshold", profile.gethighThreshold());
    result.putInt("LowThreshold", profile.getlowThreshold());
    result.putInt("Min", profile.getMin());
    result.putInt("Max", profile.getMax());
    result.putInt("BaudRate", profile.getBaudRate());
    result.putInt("PreambleFactor", profile.getPreAmbleFactor());
    result.putInt("ShuttleChannel", profile.getShuttleChannel());
    result.putInt("ForceHeadsetPlug", profile.getForceHeadsetPlug());
    result.putInt("UseVoiceRecognition", profile.getUseVoiceRecognition());
    result.putInt("VolumeLevelAdjust", profile.getVolumeLevelAdjust());
    return result;
  }
}
