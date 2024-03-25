## TEST MOBILE (Flutter) - ipaddress:8080
```
flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0
```

## TEST MOBILE (Python) - ipaddress:8080
```
flutter clean
flutter pub get
flutter build web --release --web-renderer canvaskit
cd build/web
python -m http.server 8080
```

### MOBILE DEBUGGING
1 - Open Chrome in mobile phone\
2 - Go chrome://inspect Make sure this is the only tab open\
3 - Click the button to enable JavaScript logging\
4 - Open flutter web site in other tab\
5 - You can see logs

## DEPLOY SITE FOR TEST
```
flutter clean
flutter pub get
flutter build web --release --web-renderer canvaskit
firebase deploy
```
Don't forget increment version number in pubspec.yaml if you need