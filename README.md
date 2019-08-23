# Swift向け単体テスト(Unit Test)の作り方

- [Swift向け単体テスト(Unit Test)の作り方](#swift%e5%90%91%e3%81%91%e5%8d%98%e4%bd%93%e3%83%86%e3%82%b9%e3%83%88unit-test%e3%81%ae%e4%bd%9c%e3%82%8a%e6%96%b9)
  - [はじめに](#%e3%81%af%e3%81%98%e3%82%81%e3%81%ab)
    - [目的](#%e7%9b%ae%e7%9a%84)
    - [関連する記事](#%e9%96%a2%e9%80%a3%e3%81%99%e3%82%8b%e8%a8%98%e4%ba%8b)
    - [実行環境](#%e5%ae%9f%e8%a1%8c%e7%92%b0%e5%a2%83)
    - [ソースコード](#%e3%82%bd%e3%83%bc%e3%82%b9%e3%82%b3%e3%83%bc%e3%83%89)
  - [テストシナリオ](#%e3%83%86%e3%82%b9%e3%83%88%e3%82%b7%e3%83%8a%e3%83%aa%e3%82%aa)
  - [かけ算メソッドの実装](#%e3%81%8b%e3%81%91%e7%ae%97%e3%83%a1%e3%82%bd%e3%83%83%e3%83%89%e3%81%ae%e5%ae%9f%e8%a3%85)
  - [テスト環境の準備](#%e3%83%86%e3%82%b9%e3%83%88%e7%92%b0%e5%a2%83%e3%81%ae%e6%ba%96%e5%82%99)
    - [Unit Testsを事前に準備する場合](#unit-tests%e3%82%92%e4%ba%8b%e5%89%8d%e3%81%ab%e6%ba%96%e5%82%99%e3%81%99%e3%82%8b%e5%a0%b4%e5%90%88)
    - [Unit Testsを後から準備する場合](#unit-tests%e3%82%92%e5%be%8c%e3%81%8b%e3%82%89%e6%ba%96%e5%82%99%e3%81%99%e3%82%8b%e5%a0%b4%e5%90%88)
  - [テストケースの作成](#%e3%83%86%e3%82%b9%e3%83%88%e3%82%b1%e3%83%bc%e3%82%b9%e3%81%ae%e4%bd%9c%e6%88%90)
  - [テストの実施](#%e3%83%86%e3%82%b9%e3%83%88%e3%81%ae%e5%ae%9f%e6%96%bd)
    - [単体でテストを実施する場合](#%e5%8d%98%e4%bd%93%e3%81%a7%e3%83%86%e3%82%b9%e3%83%88%e3%82%92%e5%ae%9f%e6%96%bd%e3%81%99%e3%82%8b%e5%a0%b4%e5%90%88)
    - [全体でテストを実施する場合](#%e5%85%a8%e4%bd%93%e3%81%a7%e3%83%86%e3%82%b9%e3%83%88%e3%82%92%e5%ae%9f%e6%96%bd%e3%81%99%e3%82%8b%e5%a0%b4%e5%90%88)
  - [気をつけるポイント](#%e6%b0%97%e3%82%92%e3%81%a4%e3%81%91%e3%82%8b%e3%83%9d%e3%82%a4%e3%83%b3%e3%83%88)

## はじめに

Mac環境の記事ですが、Windows環境も同じ手順になります。環境依存の部分は読み替えてお試しください。

### 目的

この記事を最後まで読むと、次のことができるようになります。

- テスト環境を準備する
- 単体テスト(Unit Test)を作成する

`テストターケッド`

```ViewController.swift
import UIKit

class ViewController: UIViewController {

    var subClass: SubClass!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.subClass = SubClass(viewController: self)
    }

    class SubClass {
        private let viewController: ViewController

        init(viewController: ViewController) {
            self.viewController = viewController
        }

        func multiply(num1: Int, num2: Int) -> Int {
            return num1 * num2
        }
    }

}
```

`テストコード`

```swift_UnitTestTests.swift
import XCTest
@testable import swift_UnitTest

class swift_UnitTestTests: XCTestCase {

    var viewController: ViewController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.viewController = storyboard.instantiateInitialViewController() as? ViewController
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        viewController.loadViewIfNeeded()
        let subClass = viewController.subClass
        let result = subClass?.multiply(num1: 7, num2: 28)
        XCTAssertEqual(result, 196)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
```

`テスト結果`

<img width="250" alt="スクリーンショット 2019-08-23 16.29.24.png" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/326996/313b83d9-b9a6-f05c-1870-7e6750726e1f.png">

### 関連する記事

- [XCTest](https://developer.apple.com/documentation/xctest)
- [XCTestCase](https://developer.apple.com/documentation/xctest/xctestcase)

### 実行環境

| 環境         | Ver.    |
| ------------ | ------- |
| macOS Mojave | 10.14.6 |
| Xcode        | 10.3    |

### ソースコード

実際に実装内容やソースコードを追いながら読むとより理解が深まるかと思います。是非ご活用ください。

[GitHub](https://github.com/nsuhara/swift-UnitTest.git)

## テストシナリオ

1. ViewControllerに**かけ算**の結果を返すメソッドを作成する

1. **かけ算**の結果が正常であるか単体テストにて確認する

## かけ算メソッドの実装

```ViewController.swift
import UIKit

class ViewController: UIViewController {

    var subClass: SubClass!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.subClass = SubClass(viewController: self)
    }

    class SubClass {
        private let viewController: ViewController

        init(viewController: ViewController) {
            self.viewController = viewController
        }

        func multiply(num1: Int, num2: Int) -> Int {
            return num1 * num2
        }
    }

}
```

## テスト環境の準備

ファイル構成はこのようになります。

<img width="250" alt="スクリーンショット 2019-08-23 10.00.24.png" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/326996/add4a9e0-06a1-000e-f8b0-1f9f1d32c87a.png">

### Unit Testsを事前に準備する場合

プロジェクトの作成時に**Include Unit Tests**にチェックを入れて作成する

<img width="500" alt="スクリーンショット 2019-08-23 9.57.15.png" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/326996/dfbd3956-7af0-f533-1d99-435fdc808888.png">

### Unit Testsを後から準備する場合

File > New > **Target...**をクリックする

Testセクションの中の**iOS Unit Testing Bundle**を選択してNextをクリッックする

<img width="500" alt="スクリーンショット 2019-08-23 17.20.49.png" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/326996/8842a8fd-2ca9-539a-51d8-2ad1cea4719b.png">

情報を入力してFinishをクリッックする

<img width="500" alt="スクリーンショット 2019-08-23 17.24.19.png" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/326996/2304ed37-169b-cdb4-2f94-5ab193322c4d.png">

## テストケースの作成

```swift_UnitTestTests.swift
import XCTest
@testable import swift_UnitTest

class swift_UnitTestTests: XCTestCase {

    var viewController: ViewController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.viewController = storyboard.instantiateInitialViewController() as? ViewController
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        viewController.loadViewIfNeeded()
        let subClass = viewController.subClass
        let result = subClass?.multiply(num1: 7, num2: 28)
        XCTAssertEqual(result, 196)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
```

## テストの実施

### 単体でテストを実施する場合

行番号上の**再生ボタン**をクリックする

<img width="500" alt="スクリーンショット 2019-08-23 17.40.01.png" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/326996/d3695a01-8883-4d67-31e2-af445ca28ceb.png">

### 全体でテストを実施する場合

Product > **Test**をクリックする

## 気をつけるポイント

CocoaPodsでパッケージをインストールしている場合は、テスト環境でパッケージが読み込めずエラーとなる

PodfileのTargetにテスト環境を追加して更新する

例) パッケージ(Kanna)をインストールした場合

```Podfile.rb
# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'swift_UnitTest' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  # Pods for swift_UnitTest
  pod 'Kanna', '4.0.3'
end

target 'swift_UnitTestTests' do
  inherit! :search_paths
  # Pods for testing
  pod 'Kanna', '4.0.3'
end
```

```Command.sh
pod update
```
