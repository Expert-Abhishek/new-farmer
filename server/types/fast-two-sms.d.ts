declare module 'fast-two-sms' {
  interface Fast2SmsOptions {
    authorization: string;
    message: string;
    numbers: string[];
    sender_id?: string;
    route?: string;
    flash?: number;
  }

  interface Fast2SmsResponse {
    return: boolean;
    request_id: string;
    message: string[];
  }

  export function sendMessage(options: Fast2SmsOptions): Promise<Fast2SmsResponse>;
  export function getWalletBalance(options: { authorization: string }): Promise<any>;
}