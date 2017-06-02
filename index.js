var IDTECH_MSR_audio = require('react-native').NativeModules.IDTECH_MSR_audio;

module.exports = {
  activate: IDTECH_MSR_audio.activate,
  deactivate: IDTECH_MSR_audio.deactivate,
  swipe: IDTECH_MSR_audio.swipe,
};
