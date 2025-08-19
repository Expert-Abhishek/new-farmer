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
        const urlParams = new URLSearchParams(window.location.search);
        const token = urlParams.get('token');
        
        console.log('Current URL:', window.location.href);
        console.log('URL params:', window.location.search);
        console.log('Token extracted:', token);

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
          <div className="w-16 h-16 mx-auto mb-4 rounded-full bg-primary/10 flex items-center justify-center">
            {status === "loading" && <Mail className="w-8 h-8 text-primary animate-pulse" />}
            {status === "success" && <CheckCircle className="w-8 h-8 text-green-600" />}
            {status === "error" && <XCircle className="w-8 h-8 text-destructive" />}
          </div>
          <CardTitle className="text-2xl font-bold">
            {status === "loading" && "Verifying Email Change"}
            {status === "success" && "Email Updated Successfully"}
            {status === "error" && "Verification Failed"}
          </CardTitle>
          <CardDescription className="text-muted-foreground">
            {message}
          </CardDescription>
        </CardHeader>
        
        <CardContent className="space-y-4">
          {status === "success" && (
            <div className="bg-green-50 dark:bg-green-950 border border-green-200 dark:border-green-800 rounded-lg p-4">
              <div className="flex items-center">
                <CheckCircle className="w-5 h-5 text-green-600 mr-2" />
                <span className="text-green-800 dark:text-green-200 text-sm">
                  You can now use your new email address to log in
                </span>
              </div>
            </div>
          )}
          
          {status === "error" && (
            <div className="bg-red-50 dark:bg-red-950 border border-red-200 dark:border-red-800 rounded-lg p-4">
              <div className="flex items-center">
                <XCircle className="w-5 h-5 text-red-600 mr-2" />
                <span className="text-red-800 dark:text-red-200 text-sm">
                  Please request a new email change if needed
                </span>
              </div>
            </div>
          )}
          
          {status === "success" && (
            <div className="text-center">
              <p className="text-sm text-muted-foreground mb-4">
                Redirecting to login page in a few seconds...
              </p>
              <Button onClick={() => setLocation("/login")} variant="outline">
                Go to Login Now
              </Button>
            </div>
          )}
          
          {status === "error" && (
            <div className="flex flex-col space-y-2">
              <Button onClick={() => setLocation("/account")} variant="outline">
                Back to Account Settings
              </Button>
              <Button onClick={() => window.location.reload()}>
                Try Again
              </Button>
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
}