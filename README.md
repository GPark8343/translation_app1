 Unhandled Exception: gRPC Error (code: 11, codeName: OUT_OF_RANGE, message: Audio Timeout Error: Long duration elapsed without audio. Audio should be sent close to real time., details: [])
 이거 발생시 리코더 다시 시작하게 하기
 Exceeded maximum allowed stream duration of 305 seconds.



 1. 터미널 혹은 커맨드창에서 '빌드하고 싶은 플러터 프로젝트 디렉토리로 이동'



 

2. 명령어 flutter build apk --release --target-platform=android-arm64 입력

 

3. 빌드 경로는  [Project Forder]/build/app/outputs/apk/release/app-release.apk 입니다. 해당 파일을 안드로이드 폰에 옮겨서 설치하면 완료!


만들고 나서 바로 녹음하면 또 설정하라네 -> 해결

지우고 나서 녹음하면 ㅈ됨 -> 그냥 기록이 안되네

녹음 중에 기록 버튼 누르면 ㅈ됨 -> 해결

300초 넘으면 자동 저장 후 다시 시작 -> 나중에

bottomnavigator 이동 시 10초 뒤에 시작하는 함수 중 context를 포함 할 시 원래 위젯에 있던 context가 사라져서 에러 나므로 tap screen 밖에 있는 main screen 에서 함수 만들고 물려주면 됨

마찬가지로 함수 실행하는 도중 화면 전환 시 에러 나는데      final translatedCurrentText = await translateText(currentText, 'ko')
              .onError((error, stackTrace) => ''); 처럼 onerror 처리 하면 그만이야
