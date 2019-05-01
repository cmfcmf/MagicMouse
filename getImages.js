const getImages = (x, y) => {
  // Based on this Gist by @ciaranj
  // https://gist.github.com/ciaranj/7177fb342102e571db2784dc831f868b
  // which is based on this StackOverflow answer by Édouard Mercier:
  // https://stackoverflow.com/a/50916681/2560557
  const calculateContainsWindow = element => {
    const imageComputedStyle = window.getComputedStyle(element);
    const imageObjectFit = imageComputedStyle.getPropertyValue("object-fit");
    const coords = {};
    const imagePositions = imageComputedStyle
      .getPropertyValue("object-position")
      .split(" ");
    let naturalWidth = element.naturalWidth;
    let naturalHeight = element.naturalHeight;
    if (element.tagName === "VIDEO") {
      naturalWidth = element.videoWidth;
      naturalHeight = element.videoHeight;
    } else if (element.tagName === "CANVAS") {
      naturalWidth = element.width;
      naturalHeight = element.height;
    }
    const horizontalPercentage = parseInt(imagePositions[0]) / 100;
    const verticalPercentage = parseInt(imagePositions[1]) / 100;
    const naturalRatio = naturalWidth / naturalHeight;
    const visibleRatio = element.clientWidth / element.clientHeight;

    if (imageObjectFit === "none") {
      coords.sourceWidth = element.clientWidth;
      coords.sourceHeight = element.clientHeight;
      coords.sourceX =
        (naturalWidth - element.clientWidth) * horizontalPercentage;
      coords.sourceY =
        (naturalHeight - element.clientHeight) * verticalPercentage;
      coords.destinationWidthPercentage = 1;
      coords.destinationHeightPercentage = 1;
      coords.destinationXPercentage = 0;
      coords.destinationYPercentage = 0;
    } else if (
      imageObjectFit === "contain" ||
      imageObjectFit === "scale-down"
    ) {
      // TODO: handle the "scale-down" appropriately, once its meaning will be clear
      coords.sourceWidth = naturalWidth;
      coords.sourceHeight = naturalHeight;
      coords.sourceX = 0;
      coords.sourceY = 0;
      if (naturalRatio > visibleRatio) {
        coords.destinationWidthPercentage = 1;
        coords.destinationHeightPercentage =
          naturalHeight /
          element.clientHeight /
          (naturalWidth / element.clientWidth);
        coords.destinationXPercentage = 0;
        coords.destinationYPercentage =
          (1 - coords.destinationHeightPercentage) * verticalPercentage;
      } else {
        coords.destinationWidthPercentage =
          naturalWidth /
          element.clientWidth /
          (naturalHeight / element.clientHeight);
        coords.destinationHeightPercentage = 1;
        coords.destinationXPercentage =
          (1 - coords.destinationWidthPercentage) * horizontalPercentage;
        coords.destinationYPercentage = 0;
      }
    } else if (imageObjectFit === "cover") {
      if (naturalRatio > visibleRatio) {
        coords.sourceWidth = naturalHeight * visibleRatio;
        coords.sourceHeight = naturalHeight;
        coords.sourceX =
          (naturalWidth - coords.sourceWidth) * horizontalPercentage;
        coords.sourceY = 0;
      } else {
        coords.sourceWidth = naturalWidth;
        coords.sourceHeight = naturalWidth / visibleRatio;
        coords.sourceX = 0;
        coords.sourceY =
          (naturalHeight - coords.sourceHeight) * verticalPercentage;
      }
      coords.destinationWidthPercentage = 1;
      coords.destinationHeightPercentage = 1;
      coords.destinationXPercentage = 0;
      coords.destinationYPercentage = 0;
    } else if (imageObjectFit === "fill") {
      coords.sourceWidth = naturalWidth;
      coords.sourceHeight = naturalHeight;
      coords.sourceX = 0;
      coords.sourceY = 0;
      coords.destinationWidthPercentage = 1;
      coords.destinationHeightPercentage = 1;
      coords.destinationXPercentage = 0;
      coords.destinationYPercentage = 0;
    } else {
      console.error(
        "unexpected 'object-fit' attribute with value '" +
          imageObjectFit +
          "' relative to"
      );
    }
    return coords;
  };

  return Promise.all(
    document
      .elementsFromPoint(x, y)
      .filter(
        element => element.tagName === "IMG" || element.tagName === "CANVAS"
      )
      .map(async imgOrCanvas => {
        // Convert an <img> element to a base64-encoded string.
        const img2Base64 = (img) => {
          const canvas = document.createElement("canvas");
          canvas.width = img.naturalWidth;
          canvas.height = img.naturalHeight;
          const ctx = canvas.getContext("2d");
          ctx.drawImage(img, 0, 0);
          return canvas.toDataURL("image/png").split(",")[1];
        };

        // Danger! These coordinates might be negative if the element is part way outside the visible screen area
        const rect = imgOrCanvas.getBoundingClientRect();
        const style = window.getComputedStyle(imgOrCanvas);

        const offsetX = parseInt(style.paddingLeft, 10);
        const offsetY = parseInt(style.paddingTop, 10);

        if (imgOrCanvas.tagName === "IMG") {
          const img = imgOrCanvas;
          const w = img.width;
          const h = img.height;

          const data = img2Base64(img);

          return {
            x: rect.x + offsetX,
            y: rect.y + offsetY,
            w,
            h,
            data
          };
        } else {
          const canvas = imgOrCanvas;
          const data = canvas.toDataURL("image/png").split(",")[1];

          let x = rect.x + offsetX;
          let y = rect.y + offsetY;
          let w = rect.width;
          let h = rect.height;

          if (
            style.objectFit === "contain" &&
            style.objectPosition === "50% 50%"
          ) {
            const c = calculateContainsWindow(canvas);
            x += c.destinationXPercentage * rect.width;
            y += c.destinationYPercentage * rect.height;
            w = c.destinationWidthPercentage * w;
            h = c.destinationHeightPercentage * h;
          }

          return { x, y, w, h, data };
        }
      })
  );
};

module.exports = {
  getImages
};
