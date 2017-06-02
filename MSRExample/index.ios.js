/**
 * Example React Native App using react-native-idtech-msr-audio
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
      swiping: false,
    };

    this.startSwipe = this.startSwipe.bind(this);
  }

  componentWillMount() {
    // Listen for events from the card reader.
    const IdTechUniMagEvent = new NativeEventEmitter(NativeModules.IDTECH_MSR_audio);
    this.IdTechUniMagEventSub = IdTechUniMagEvent.addListener(
      'IdTechUniMagEvent',
      (response) => {
        let swiping = this.state.swiping;
        let connected = this.state.connected;
        let texts = [response.type, response.message]

        if (response.type === 'umConnection_connected') {
          connected = true;
        }

        let details = [];
        for (let i=0; i<texts.length; i++) {
          details.push(
            <Text style={styles.details} key={i}>
              {texts[i]}
            </Text>
          );
        }
        if (response.type === 'umSwipe_receivedSwipe') {
          swiping = false;
          for (let i=0; i<response.data.tracks.length; i++) {
            details.push(
              <Text style={styles.details} key={'track' + i}>
                Track {i+1}: {response.data.tracks[i]}
              </Text>
            );
          }
        }
        this.setState({details, connected, swiping});
      }
    );
  }

  componentWillUnmount() {
    this.IdTechUniMagEventSub.remove();
  }

  connectReader() {
    // Initiate a transaction on the card reader.
    this.setState({connecting: true});
    // Params: 4 = Shuttle, 0 = infinite timeout, false = no logging
    IDTECH_MSR_audio.activate(4, 0, false).then(
      (response) =>{
        let connecting = false;
        let details = (
          <Text style={styles.details}>
            {response.message}
          </Text>
        )
        this.setState({connecting, details});

        // console.log("IDTECH_MSR_audio activation response:" + JSON.stringify(response));
    });
  }

  disconnectReader() {
    IDTECH_MSR_audio.deactivate();
    this.setState({connecting: false, connected: false, swiping: false, details: []});
  }

  startSwipe() {
    IDTECH_MSR_audio.swipe();
    this.setState({swiping: true});
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

        { this.state.connected && !this.state.swiping &&
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
