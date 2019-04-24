using Automata_Expedition.Classes;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.UI;
using Windows.UI.ViewManagement;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Data;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Navigation;

// 빈 페이지 항목 템플릿에 대한 설명은 https://go.microsoft.com/fwlink/?LinkId=234238에 나와 있습니다.

namespace Automata_Expedition.Views
{
    /// <summary>
    /// 자체적으로 사용하거나 프레임 내에서 탐색할 수 있는 빈 페이지입니다.
    /// </summary>
    public sealed partial class SettingsPage : Page
    {
        public SettingsPage()
        {
            this.InitializeComponent();
            this.NavigationCacheMode = Windows.UI.Xaml.Navigation.NavigationCacheMode.Enabled;

            toggleSound.IsOn = Game.Instance.ElementSoundPlayerState == ElementSoundPlayerState.On;
            checkSpacialSound.IsChecked = Game.Instance.ElementSpatialAudioMode == ElementSpatialAudioMode.On;
        }

        private void ToggleSound_Toggled(object sender, RoutedEventArgs e)
        {
            if (toggleSound.IsOn == true)
            {
                ElementSoundPlayer.State = ElementSoundPlayerState.On;
                Game.Instance.ElementSoundPlayerState = ElementSoundPlayerState.On;
                checkSpacialSound.IsEnabled = true;
            }
            else
            {
                ElementSoundPlayer.State = ElementSoundPlayerState.Off;
                Game.Instance.ElementSoundPlayerState = ElementSoundPlayerState.Off;
                checkSpacialSound.IsEnabled = false;
            }
        }

        private void CheckSpacialSound_Checked(object sender, RoutedEventArgs e)
        {
            ElementSoundPlayer.SpatialAudioMode = ElementSpatialAudioMode.On;
            Game.Instance.ElementSpatialAudioMode = ElementSpatialAudioMode.On;
        }

        private void CheckSpacialSound_Unchecked(object sender, RoutedEventArgs e)
        {
            ElementSoundPlayer.SpatialAudioMode = ElementSpatialAudioMode.Off;
            Game.Instance.ElementSpatialAudioMode = ElementSpatialAudioMode.Off;
        }

        private void RadioTheme_Checked(object sender, RoutedEventArgs e)
        {
            var selectedTheme = ((RadioButton)sender)?.Tag?.ToString();
            ApplicationViewTitleBar titleBar = ApplicationView.GetForCurrentView().TitleBar;

            if (selectedTheme != null)
            {
                App.RootTheme = App.GetEnum<ElementTheme>(selectedTheme);
                if (selectedTheme == "Dark")
                {
                    titleBar.ButtonForegroundColor = Colors.White;
                }
                else if (selectedTheme == "Light")
                {
                    titleBar.ButtonForegroundColor = Colors.Black;
                }
                else
                {
                    if (Application.Current.RequestedTheme == ApplicationTheme.Dark)
                    {
                        titleBar.ButtonForegroundColor = Colors.White;
                    }
                    else
                    {
                        titleBar.ButtonForegroundColor = Colors.Black;
                    }
                }
            }
        }
    }
}
