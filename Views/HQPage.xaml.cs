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
        }

        private void BtnEditName_Click(object sender, RoutedEventArgs e)
        {
            string name = txtPlayerName.Text;
            TextBox textBox = new TextBox();
            textBox.Name = "boxEditName";
            textBox.PlaceholderText = "새 이름";
            textBox.MinWidth = 100;
            textBox.PointerExited += boxEditName_Completed;
            stkPlayerName.Children.RemoveAt(0);
            stkPlayerName.Children.Insert(0, textBox);
        }

        private void boxEditName_Completed(object sender, RoutedEventArgs e)
        {
            TextBox textBox = FindName("boxEditName") as TextBox;
            string name = textBox.Text;
            TextBlock textBlock = new TextBlock();
            textBlock.Name = "txtPlayerName";
            textBlock.Text = name;
            textBlock.Style = (Style)Application.Current.Resources["TitleTextBlockStyle"];
            stkPlayerName.Children.RemoveAt(0);
            stkPlayerName.Children.Insert(0, textBlock);
        }

        private async void BtnSave_Click(object sender, RoutedEventArgs e)
        {
            Windows.Storage.StorageFolder storageFolder = Windows.Storage.ApplicationData.Current.LocalFolder;
            Windows.Storage.StorageFile storageFile =
                await storageFolder.CreateFileAsync(SAVE_FILE, Windows.Storage.CreationCollisionOption.OpenIfExists);

            // 파일 저장 완료 상태 설정
            Windows.Storage.Provider.FileUpdateStatus status =
                await Windows.Storage.CachedFileManager.CompleteUpdatesAsync(storageFile);

            if (status == Windows.Storage.Provider.FileUpdateStatus.Complete)
            {
                txtSaveResult.Text = "저장 완료!";
            }
            else
            {
                txtSaveResult.Text = "저장 실패...";
            }
            FlyoutBase.ShowAttachedFlyout((FrameworkElement)sender);
        }

        private async void BtnLoad_Click(object sender, RoutedEventArgs e)
        {
            Windows.Storage.StorageFolder storageFolder = Windows.Storage.ApplicationData.Current.LocalFolder;

            if (await storageFolder.TryGetItemAsync(SAVE_FILE) != null)
            {
                Windows.Storage.StorageFile storageFile =
                    await storageFolder.GetFileAsync(SAVE_FILE);

                txtLoadResult.Text = "불러오기 완료!";
            }
            else
            {
                txtLoadResult.Text = "불러오기 실패: 파일이 존재하지 않습니다.";
            }
            FlyoutBase.ShowAttachedFlyout((FrameworkElement)sender);
        }
    }
}
