import { Formatter } from 'field-kit';
import { asYouType as AsYouType } from 'libphonenumber-js';

const INTERNATIONAL_CODE_REGEX = /^\+\d{1,3} /;

const fixCountryCodeSpacing = (text, countryCode) => {
  // If the text is `+123456`, make it `+123 456`
  if (text[countryCode.length + 1] !== ' ') {
    return text.replace(`+${countryCode}`, `+${countryCode} `);
  }
  return text;
};

// Comment out USA formatting aas this was formatting all numbers like US numbers
// const getFormattedTextData = (text) => {
//   if (text === '1') {
//     text = '+1';
//   }
//
//   const asYouType = new AsYouType('US');
//   let formattedText = asYouType.input(text);
//   const countryCode = asYouType.country_phone_code;
//
//   if (asYouType.country_phone_code) {
//     formattedText = fixCountryCodeSpacing(formattedText, countryCode);
//   }
//
//   return {
//     text: formattedText,
//     template: asYouType.template,
//     countryCode,
//   };
// };

const changeRemovesInternationalCode = (current, previous) => {
  if (previous.text.match(INTERNATIONAL_CODE_REGEX) &&
     !current.text.match(INTERNATIONAL_CODE_REGEX)
  ) {
    return true;
  }
  return false;
};

const cursorPosition = (formattedTextData) => {
  // If the text is `(23 )` the cursor goes after the 3
  const match = formattedTextData.text.match(/\d[^\d]*$/);
  if (match) {
    return match.index + 1;
  }
  return formattedTextData.text.length + 1;
};

class InternationalPhoneFormatter extends Formatter {
  format(text) {
    const formattedTextData = getFormattedTextData(text);
    return super.format(formattedTextData.text);
  }

  // eslint-disable-next-line class-methods-use-this
  parse(text) {
    return text.replace(/[^\d+]/g, '');
  }

  // isChangeValid(change, error) {
  //   const formattedTextData = getFormattedTextData(change.proposed.text);
  //   const previousFormattedTextData = getFormattedTextData(change.current.text);
  //
  //   if (changeRemovesInternationalCode(formattedTextData, previousFormattedTextData)) {
  //     return false;
  //   }
  //
  //   change.proposed.text = formattedTextData.text;
  //   change.proposed.selectedRange.start = cursorPosition(formattedTextData);
  //   return super.isChangeValid(change, error);
  // }
}

export default InternationalPhoneFormatter;
