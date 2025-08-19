import { useState, useEffect } from "react";
import { useLocation } from "wouter";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Mail, CheckCircle, XCircle } from "lucide-react";
import { useToast } from "@/hooks/use-toast";
import { apiRequest } from "@/lib/queryClient";

export default function VerifyEmailChange() {
  const [location, setLocation] = useLocation();
  const { toast } = useToast();
  const [status, setStatus] = useState<"loading" | "success" | "error">("loading");
  const [message, setMessage] = useState("");

  useEffect(() => {
    const verifyEmailChange = async () => {
      try {
        // Get token from URL params
        const urlParams = new URLSearchParams(location.split('?')[1] || '');
        const token = urlParams.get('token');

        if (!token) {
          setStatus("error");
          setMessage("No verification token found in URL");
          return;
        }

        const res = await apiRequest("/api/auth/verify-email-change", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ token }),
        });

        setStatus("success");
        setMessage("Your email address has been successfully updated! Please use your new email address to log in.");
        
        toast({
          title: "Email Updated",
          description: "Your email address has been successfully changed.",
        });

        // Redirect to login after 3 seconds
        setTimeout(() => {
          setLocation("/login");
        }, 3000);

      } catch (error: any) {
        setStatus("error");
        setMessage(error.message || "Failed to verify email change");
        
        toast({
          title: "Verification Failed",
          description: error.message || "Failed to verify email change",
          variant: "destructive",
        });
      }
    };

    verifyEmailChange();
  }, [location, setLocation, toast]);

  return (
    <div className="min-h-screen bg-background flex items-center justify-center p-4">
      <Card className="w-full max-w-md">
        <CardHeader className="text-center">
          <CardTitle className="flex items-center justify-center gap-2">
            {status === "loading" && <Mail className="h-6 w-6 animate-spin" />}
            {status === "success" && <CheckCircle className="h-6 w-6 text-green-600" />}
            {status === "error" && <XCircle className="h-6 w-6 text-red-600" />}
            Email Verification
          </CardTitle>
          <CardDescription>
            {status === "loading" && "Verifying your email change..."}
            {status === "success" && "Email change verified successfully"}
            {status === "error" && "Email verification failed"}
          </CardDescription>
        </CardHeader>
        <CardContent className="text-center space-y-6">
          <div className={`p-4 rounded-lg ${
            status === "loading" ? "bg-blue-50 border border-blue-200" :
            status === "success" ? "bg-green-50 border border-green-200" :
            "bg-red-50 border border-red-200"
          }`}>
            <p className={`text-sm ${
              status === "loading" ? "text-blue-800" :
              status === "success" ? "text-green-800" :
              "text-red-800"
            }`}>
              {message}
            </p>
          </div>

          {status === "success" && (
            <div className="space-y-3">
              <p className="text-sm text-muted-foreground">
                You will be redirected to the login page automatically in a few seconds.
              </p>
              <Button onClick={() => setLocation("/login")} className="w-full">
                Go to Login Now
              </Button>
            </div>
          )}

          {status === "error" && (
            <div className="space-y-3">
              <Button onClick={() => setLocation("/account")} className="w-full">
                Back to Account
              </Button>
              <Button 
                variant="outline" 
                onClick={() => setLocation("/login")}
                className="w-full"
              >
                Go to Login
              </Button>
            </div>
          )}

          {status === "loading" && (
            <div className="flex items-center justify-center">
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
}