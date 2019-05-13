const getElements = (fn, ...args) => {
  const ID_ATTRIBUTE = "data-magic-mouse-id";

  const getIdOf = async element => {
    let id = element.getAttribute(ID_ATTRIBUTE);
    if (!id) {
      id = await window.uuid();
      element.setAttribute(ID_ATTRIBUTE, id);
    }
    return id;
  };

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

  // Convert an <img> element to a base64-encoded string.
  const img2Base64 = img => {
    const canvas = document.createElement("canvas");
    canvas.width = img.naturalWidth;
    canvas.height = img.naturalHeight;
    const ctx = canvas.getContext("2d");
    ctx.drawImage(img, 0, 0);
    return canvas.toDataURL("image/png").split(",")[1];
  };

  const extractImg = async (img, includeData = true) => {
    const rect = img.getBoundingClientRect();

    const style = window.getComputedStyle(img);
    const offsetX = parseInt(style.paddingLeft, 10);
    const offsetY = parseInt(style.paddingTop, 10);

    const w = img.width;
    const h = img.height;

    return {
      id: await getIdOf(img),
      type: "img",
      x: rect.x + offsetX,
      y: rect.y + offsetY,
      w,
      h,
      data: includeData ? img2Base64(img) : null
    };
  };

  const extractCanvas = async (canvas, includeData = true) => {
    const rect = img.getBoundingClientRect();

    const style = window.getComputedStyle(img);
    const offsetX = parseInt(style.paddingLeft, 10);
    const offsetY = parseInt(style.paddingTop, 10);

    let x = rect.x + offsetX;
    let y = rect.y + offsetY;
    let w = rect.width;
    let h = rect.height;

    if (style.objectFit === "contain" && style.objectPosition === "50% 50%") {
      const c = calculateContainsWindow(canvas);
      x += c.destinationXPercentage * rect.width;
      y += c.destinationYPercentage * rect.height;
      w = c.destinationWidthPercentage * w;
      h = c.destinationHeightPercentage * h;
    }

    return {
      id: await getIdOf(canvas),
      type: "canvas",
      x,
      y,
      w,
      h,
      data: includeData ? canvas.toDataURL("image/png").split(",")[1] : null
    };
  };

  const extractPre = async (element, includeData = true) => {
    const viewport = {
      w: document.documentElement.clientWidth,
      h: document.documentElement.clientHeight
    };

    const rect = element.getBoundingClientRect();

    let dw = 0;
    if (rect.right > viewport.w) {
      dw = rect.right - viewport.w;
    }
    let dh = 0;
    if (rect.bottom > viewport.h) {
      dh = rect.bottom - viewport.h;
    }

    const id = await getIdOf(element);

    return {
      id,
      type: "pre",
      x: rect.x,
      y: rect.y,
      w: rect.width - dw,
      h: rect.height - dh,
      data: includeData ? element.textContent : null
    };
  };

  const extract = async (element, includeData = true) => {
    if (element.tagName === "IMG") {
      return extractImg(element, includeData);
    } else if (element.tagName === "CANVAS") {
      return extractCanvas(element, includeData);
    } else if (element.tagName === "PRE") {
      return extractPre(element, includeData);
    }
  };

  const extractElements = (x, y) => {
    return Promise.all(
      document
        .elementsFromPoint(x, y)
        .filter(
          element =>
            element.tagName === "IMG" ||
            element.tagName === "CANVAS" ||
            element.tagName === "PRE"
        )
        .map(async element => extract(element))
    );
  };

  const refreshInfo = () => {
    const infos = [];

    document
      .querySelectorAll(`[${ID_ATTRIBUTE}]`)
      .forEach(element => infos.push(extract(element, false)));

    return Promise.all(infos);
  };

  switch (fn) {
    case "extractElements":
      return extractElements(...args);
    case "refreshInfo":
      return refreshInfo(...args);
  }
};

module.exports = {
  getElements
};
