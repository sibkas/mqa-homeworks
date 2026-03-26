package ru.netology.qa;

import io.appium.java_client.AppiumDriver;
import io.appium.java_client.MobileElement;
import io.appium.java_client.android.AndroidDriver;
import org.junit.jupiter.api.*;
import org.openqa.selenium.remote.DesiredCapabilities;
import ru.netology.qa.screens.MainScreen;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URL;

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
public class AppiumAppTest {

    private AppiumDriver<MobileElement> driver;

    @BeforeAll
    public void createDriver() throws MalformedURLException {
        String platform = System.getProperty("platform");
        DesiredCapabilities caps = new DesiredCapabilities();

        if ("android".equals(platform)) {
            caps.setCapability("platformName", "android");
            caps.setCapability("appium:deviceName", "Android Emulator");
            File projectRoot = new File(System.getProperty("user.dir"));
            File app = new File(projectRoot, "app/app-debug.apk");
            caps.setCapability("appium:app", app.getAbsolutePath());
            caps.setCapability("appium:automationName", "UiAutomator2");
            caps.setCapability("appium:noSign", true);
        } else {
            throw new IllegalArgumentException(String.format("Platform %s is not supported", platform));
        }

        // Если возникнет ошибка 404, то URL "http://127.0.0.1:4723/wd/hub"
        driver = new AndroidDriver<>(new URL("http://127.0.0.1:4723/"), caps);
    }

    @Test
    @DisplayName("Тест 1: Пустая строка не меняет текст")
    public void shouldNotChangeTextIfEmpty() {
        MainScreen mainScreen = new MainScreen(driver);
        String textBefore = mainScreen.textToBeChanged.getText();

        mainScreen.userInput.sendKeys(" ");
        mainScreen.buttonChange.click();

        String textAfter = mainScreen.textToBeChanged.getText();
        Assertions.assertEquals(textBefore, textAfter);
    }

    @Test
    @DisplayName("Тест 2: Текст открывается в новой Activity")
    public void shouldOpenTextInAnotherActivity() {
        MainScreen mainScreen = new MainScreen(driver);
        String textToType = "Netology";

        mainScreen.userInput.sendKeys(textToType);
        mainScreen.buttonActivity.click();

        // Поиск элемента на втором экране по ID
        MobileElement resultOnSecondScreen = driver.findElementById("ru.netology.testing.uiautomator:id/text");
        Assertions.assertEquals(textToType, resultOnSecondScreen.getText());
    }

    @AfterAll
    public void quitDriver() {
        if (driver != null) {
            driver.quit();
        }
    }
}