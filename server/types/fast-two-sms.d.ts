declare module 'fast-two-sms' {
  interface Fast2SmsOptions {
    authorization: string;
    variables_values: string; // OTP value (only numeric, up to 8 digits)
    route: string; // For OTP use "otp"
    numbers: string[]; // Mobile numbers as array (library converts to comma-separated internally)
    flash?: string; // "0" for normal SMS, "1" for flash SMS
  }

  interface Fast2SmsResponse {
    return: boolean;
    request_id: string;
    message: string[];
  }

  export function sendMessage(options: Fast2SmsOptions): Promise<Fast2SmsResponse>;
  export function getWalletBalance(options: { authorization: string }): Promise<any>;
}