# Description
This is Mobile Client of PsychoCare application. This application is written in Flutter and uses redux.

PsychoCare is an application to following user emotional states. If you feel bad or happy you can register it and add description. All emotional states are grouped per environment groups. If you feel bad because of you relationship you can select that. You can also check what state is the most frequently registered or see on timeline what emotional states you registered in given time period. Before using application you must register.

Application allows for generating QR Codes and sharing it, so other user can scan QR code an see you emotional states. This is mainly for psychologist.

Application supports only Polish language

# Requirments

1. Flutter
2. PsychoCare.API

# Installation
Simple clone repository and change in `constants.dart` api url.
for example: 
```
static const api_address = "https://psychocareapi20200505084212.azurewebsites.net";
```

# Running application
Simple run application by typing in terminal `flutter run`

# Demo
![demo](https://github.com/gtteamamxx/PsychoCare.Client/blob/master/gif.gif)
