/**
 * Copyright OnceThere
 */

import { StyleSheet } from 'react-native';

export default StyleSheet.create( {
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  titleContainer: {
    marginVertical: 20,
  },
  titleText: {
    fontSize: 20,
    textAlign: 'center',
  },
  details: {
    textAlign: 'center',
    color: '#333333',
    fontSize: 16,
    marginBottom: 5,
  },
	button: {
		borderWidth: 0.5,
		borderRadius: 8,
    backgroundColor: 'blue',
		padding: 10,
    margin: 5,
	},
  buttonDisabled: {
    backgroundColor: 'grey',
  },
  buttonText: {
    color: 'white',
  },
})
