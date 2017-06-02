/**
 * Example React Native App using react-native-idtech-msr-audio
 *
 * ToDo: implement Android native code for ID Tech reader
*/

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableHighlight,
  NativeModules, NativeEventEmitter,
} from 'react-native';
import styles from './style';

import IDTECH_MSR_audio from 'react-native-idtech-msr-audio';

class MSRExample extends Component {

  constructor(props) {
    super(props);

    this.state = {
      details: [],
      connected: false,
      connecting: false,
    };
  }

  componentWillMount() {
    // Listen for events from the card reader.
    const IdTechUniMagEvent = new NativeEventEmitter(NativeModules.IDTECH_MSR_audio);
    this.IdTechUniMagEventSub = IdTechUniMagEvent.addListener(
      'IdTechUniMagEvent',
      (response) => {
        let texts = [response.type, response.message]
        let details = [];
        for (let i=0; i<texts.length; i++) {
          details.push(
            <Text style={styles.details} key={i}>
              {texts[i]}
            </Text>
          );
        }
        if (response.type === 'umSwipe_receivedSwipe') {
          console.log("Successfully received swipe.");
          // ToDo: Display card data
        }
        this.setState({details});
      }
    );
  }

  componentWillUnmount() {
    this.IdTechUniMagEventSub.remove();
  }

  connectReader() {
    // Initiate a transaction on the card reader.
    this.setState({connecting: true});
    // Params: 4 = Shuttle, 0 timeout (infinite), no logging
    IDTECH_MSR_audio.activate(4, 0, false).then(
      (response) =>{
        let connecting = false;
        let connected = response.statusCode === 0;
        let details = (
          <Text style={styles.details}>
            {response.message}
          </Text>
        )
        this.setState({connecting, connected, details});

        // console.log("IDTECH_MSR_audio activation response:" + JSON.stringify(response));
    });
  }

  disconnectReader() {
    IDTECH_MSR_audio.deactivate();
    this.setState({connecting: false, connected: false});
  }

  startSwipe() {
    IDTECH_MSR_audio.swipe();
  }


  render() {
    let buttonStyle = this.state.connecting? styles.buttonDisabled : null;
    return (
      <View style={styles.container}>
        <View style={[styles.titleContainer]}>
          <Text style={styles.titleText}>ID TECH MagStripe Reader (audio jack)</Text>
          <Text style={styles.titleText}>React Native Integration Demo</Text>
        </View>
        <View>
          {this.state.details}
        </View>

        <TouchableHighlight
          style={[styles.button, buttonStyle]}
          disabled={this.state.connecting}
          onPress={() => this.state.connected ? this.disconnectReader() : this.connectReader()}
          underlayColor="#f1f1f1">
          <Text style={styles.buttonText}>{this.state.connected ? 'Disconnect' : 'Connect'}</Text>
        </TouchableHighlight>

        { this.state.connected &&
          <TouchableHighlight
            style={[styles.button, buttonStyle]}
            onPress={this.startSwipe}
            underlayColor="#f1f1f1">
            <Text style={styles.buttonText}>Start Swipe</Text>
          </TouchableHighlight>
        }
      </View>
    );
  }
}

AppRegistry.registerComponent('MSRExample', () => MSRExample);
