import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['inputFile', 'removeImageFlag', 'removeImageButton',
                    'newImage', 'newImageWrapper'];

  // 画像プレビューするための処理の呼び出しなど
  preview() {
    const newImageWrapper = this.newImageWrapperTarget;
    const currentImageWrapper = document.getElementById('currentImageWrapper');

    this.removePreview(newImageWrapper);
    this.displayImage(newImageWrapper);
    if (currentImageWrapper) {
      this.removeImageButtonTarget.setAttribute('class', 'd-none');
    }
    this.removeImageFlagTarget.value = false;
  }

  // 画像プレビューの削除処理
  removePreview(imageWrapper) {
    while (imageWrapper.firstChild) {
      imageWrapper.removeChild(imageWrapper.firstChild);
    }
  }

  // 新しい画像のプレビュー表示処理
  displayImage(newImageWrapper) {
    if (this.inputFileTarget.value.length === 0) {
      return;
    }

    const newImageElement = this.newImageTarget.content.cloneNode(true);
    const imagePath = URL.createObjectURL(this.inputFileTarget.files[0]);

    newImageElement.querySelector('img').setAttribute('src', imagePath);
    newImageWrapper.appendChild(newImageElement);
  }

  // 新しい画像の削除のための処理の呼び出しなど
  cancelNewImage() {
    const newImageWrapper = this.newImageWrapperTarget;
    const currentImageWrapper = document.getElementById('currentImageWrapper');

    this.removePreview(newImageWrapper);
    this.inputFileTarget.value = '';
    if (currentImageWrapper) {
      this.removeImageButtonTarget.removeAttribute('class', 'd-none');
    } else {
      this.removeImageFlagTarget.value = true;
    }
  }

  // 現在の画像の削除処理
  removeImage() {
    const currentImageWrapper = document.getElementById('currentImageWrapper');
    currentImageWrapper.remove();
    this.removeImageFlagTarget.value = true;
  }
}
