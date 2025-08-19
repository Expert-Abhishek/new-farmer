import { useState } from "react";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Mail } from "lucide-react";
import { useAuth } from "@/context/AuthContext";
import { useToast } from "@/hooks/use-toast";
import { apiRequest } from "@/lib/queryClient";
import { Input } from "@/components/ui/input";

export default function ChangeEmailUser() {
  const { token, user } = useAuth();
  const { toast } = useToast();
  const [showChangeFlow, setShowChangeFlow] = useState(false);
  const [newEmail, setNewEmail] = useState("");
  const [loading, setLoading] = useState(false);

  const handleSendVerificationEmail = async () => {
    if (!user || !token) return;

    try {
      setLoading(true);
      const res = await apiRequest("/api/auth/request-email-change", {
        method: "POST",
        headers: { 
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({
          newEmail,
        }),
      });

      toast({
        title: "Verification Email Sent",
        description: "Please check your current email address for verification link.",
      });
      
      // Reset form after successful request
      setShowChangeFlow(false);
      setNewEmail("");
    } catch (error: any) {
      toast({
        title: "Request Failed",
        description: error.message || "Failed to send verification email",
        variant: "destructive",
      });
    } finally {
      setLoading(false);
    }
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <Mail className="h-5 w-5" />
          Change Email
        </CardTitle>
        <CardDescription>
          Update the email address associated with your account.
        </CardDescription>
      </CardHeader>
      <CardContent>
        {!showChangeFlow ? (
          <Button
            onClick={() => setShowChangeFlow(true)}
            variant="outline"
            className="w-full"
          >
            <Mail className="h-4 w-4 mr-2" />
            Change Email
          </Button>
        ) : (
          <div className="space-y-4">
            <div className="p-4 bg-yellow-50 border border-yellow-200 rounded-lg">
              <p className="text-sm text-yellow-800">
                <strong>Current Email:</strong> {(user as any)?.email}
              </p>
            </div>
            <Input
              type="email"
              placeholder="Enter new email address"
              value={newEmail}
              onChange={(e) => setNewEmail(e.target.value)}
              disabled={loading}
            />
            <div className="p-4 bg-blue-50 border border-blue-200 rounded-lg">
              <p className="text-sm text-blue-800">
                <strong>Important:</strong> A verification email will be sent to your current email address ({(user as any)?.email}) to confirm this change.
              </p>
            </div>
            <div className="flex gap-4">
              <Button onClick={handleSendVerificationEmail} disabled={!newEmail || loading}>
                {loading ? "Sending Email..." : "Send Verification Email"}
              </Button>
              <Button
                variant="outline"
                onClick={() => {
                  setShowChangeFlow(false);
                  setNewEmail("");
                }}
              >
                Cancel
              </Button>
            </div>
          </div>
        )}
      </CardContent>
    </Card>
  );
}
