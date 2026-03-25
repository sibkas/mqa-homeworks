//
//  Created by Netology.
//

import XCTest

class NetologyUITests: XCTestCase {

    
    func testLogin() throws {
        let app = XCUIApplication()
        app.launch()

        let username = "username"

        let loginTextField = app.textFields["login"]
        loginTextField.tap()
        loginTextField.typeText(username)

        let passwordTextField = app.textFields["password"]
        passwordTextField.tap()
        passwordTextField.typeText("123456")

        let loginButton = app.buttons["login"]
        XCTAssertTrue(loginButton.isEnabled)
        loginButton.tap()

        let predicate = NSPredicate(format: "label CONTAINS[c] %@", username)
        let text = app.staticTexts.containing(predicate)
        XCTAssertNotNil(text)

        let fullScreenshot = XCUIScreen.main.screenshot()
        let screenshot = XCTAttachment(screenshot: fullScreenshot)
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }
    

    // Задание 1: Проверка блокировки кнопки при пустом логине
    func testLoginButtonDisabledWhenLoginCleared() throws {
        let app = XCUIApplication()
        app.launch()

        let loginTextField = app.textFields["login"]
        loginTextField.tap()
        loginTextField.typeText("user")

        let passwordTextField = app.textFields["password"]
        passwordTextField.tap()
        passwordTextField.typeText("123456")

        // Стираем введённый логин
        let loginValue = loginTextField.value as? String ?? ""
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: loginValue.count)
        loginTextField.typeText(deleteString)

        let loginButton = app.buttons["login"]
        // Проверяем, что кнопка Login не активна
        XCTAssertFalse(loginButton.isEnabled)
    }

    // Задание 2: Проверка смены пользователя
    func testChangeUserAndCheckProfileLogin() throws {
        let app = XCUIApplication()
        app.launch()

        let firstUser = "firstUser"
        let secondUser = "secondUser"

        // 1. Вводим логин и пароль первого пользователя
        let loginTextField = app.textFields["login"]
        loginTextField.tap()
        loginTextField.typeText(firstUser)

        let passwordTextField = app.textFields["password"]
        passwordTextField.tap()
        passwordTextField.typeText("123456")
        
        // 2. Нажимаем кнопку Login
        app.buttons["login"].tap()

        // 3. Нажимаем кнопку Назад (обычно это первая кнопка в Navigation Bar)
        app.navigationBars.buttons.element(boundBy: 0).tap()

        // 4. Стираем старый логин и вводим другой
        loginTextField.tap()
        let currentLogin = loginTextField.value as? String ?? ""
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: currentLogin.count)
        loginTextField.typeText(deleteString)
        
        loginTextField.typeText(secondUser)

        // 5. Нажимаем кнопку Login
        app.buttons["login"].tap()

        // 6. Проверяем, что логин на экране Profile совпадает со вторым логином
        let profileText = app.staticTexts[secondUser]
        XCTAssertTrue(profileText.exists)
    }
}
