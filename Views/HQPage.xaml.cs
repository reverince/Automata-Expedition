using Automata_Expedition.Classes;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using Windows.Foundation;
using Windows.Foundation.Collections;
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
    public sealed partial class HQPage : Page
    {
        const string SAVE_FILE = "save.txt";

        public HQPage()
        {
            this.InitializeComponent();
            this.NavigationCacheMode = Windows.UI.Xaml.Navigation.NavigationCacheMode.Enabled;

            UpdateComponent();
        }

        private void UpdateComponent()
        {
            txtPlayerName.Text = Game.Instance.Player.Name;
        }

        private void BtnEditName_Click(object sender, RoutedEventArgs e)
        {
            string name = txtPlayerName.Text;
            TextBox textBox = new TextBox();
            textBox.Name = "boxEditName";
            textBox.PlaceholderText = "새 이름";
            textBox.MinWidth = 100;
            textBox.KeyDown += boxEditName_Finish;
            stkPlayerName.Children.RemoveAt(0);
            stkPlayerName.Children.Insert(0, textBox);
            textBox.Focus(FocusState.Programmatic);
        }

        private void boxEditName_Finish(object sender, KeyRoutedEventArgs e)
        {
            if (e.Key == Windows.System.VirtualKey.Enter)
            {
                TextBox textBox = FindName("boxEditName") as TextBox;
                string name = textBox.Text;
                Game.Instance.Player.Name = name;
                TextBlock textBlock = new TextBlock();
                textBlock.Name = "txtPlayerName";
                textBlock.Text = name;
                textBlock.Style = (Style)Application.Current.Resources["TitleTextBlockStyle"];
                stkPlayerName.Children.RemoveAt(0);
                stkPlayerName.Children.Insert(0, textBlock);

                UpdateComponent();
            }
        }

        private void BtnSave_Click(object sender, RoutedEventArgs e)
        {
            GameManager.Save();
            txtSaveResult.Text = "저장 완료!";
            FlyoutBase.ShowAttachedFlyout((FrameworkElement)sender);
        }

        private async void BtnLoad_Click(object sender, RoutedEventArgs e)
        {
            GameManager.Load();
            Windows.Storage.ApplicationDataContainer localSettings = Windows.Storage.ApplicationData.Current.LocalSettings;

            if (localSettings.Values.ContainsKey("Game"))
            {
                GameManager.Load();
                txtLoadResult.Text = "불러오기 완료!";

                UpdateComponent();
            }
            else
            {
                txtLoadResult.Text = "불러오기 실패: 파일이 존재하지 않습니다.";
            }
            FlyoutBase.ShowAttachedFlyout((FrameworkElement)sender);
        }
    }
}
