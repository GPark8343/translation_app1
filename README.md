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


  if (widget.pageIndex == 0 && recognizing) {}translation screen 95번쨰 줄에서 멈췄는데 계속 recognizing 트루로 나와서 10초뒤에 비정상적으로 모델을 보여줌 고쳐야됨 -> translation screen에 pageindex 변수 추가해서 가능하게 함





  이제 permission handler 이용해서 마이크 버튼 누를 때 권한 묻고,(30분) -> 완료
   앱 이용약관이랑 개인정보처리 방침 세우고 
   앱 시작 전에 설치한 후에 한 번만 묻도록 한 뒤(sqflite로 해보자 왜냐하면 한 번만 묻는 건 얘야), (1시간~1시간 30분) -> 완료
   play store 제출



 // var findedHistory =
                                    //     await Provider.of<HistoryManage>(
                                    //             context,
                                    //             listen: false)
                                    //         .findById(historyId); //이거 되냐

target language와 original language 2개를 구분해서 history db에 저장(언어 늘린다면)


'package:flutter/src/animation/animation_controller.dart': Failed assertion: line 821 pos 12: 'elapsedInSeconds >= 0.0': is not true.
이거 오류 머임?

setapiscreen에서 validator 설정하기