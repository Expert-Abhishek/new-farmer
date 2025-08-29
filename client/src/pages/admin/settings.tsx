import React from "react";
import { useQuery, useMutation } from "@tanstack/react-query";
import { apiRequest } from "@/lib/queryClient";
import { queryClient } from "@/lib/queryClient";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Separator } from "@/components/ui/separator";
import { useToast } from "@/hooks/use-toast";
import { Save, Store, Globe, Upload, X, Image } from "lucide-react";
import AdminLayout from "@/components/admin/AdminLayout";
import MainLoader from "@/utils/MainLoader";
import { getImageUrl } from "@/utils/imageUtils";
import placeholderImage from "../../../../public/uploads/products/No-Image.png";

interface SiteSetting {
  id: number;
  key: string;
  value: string | null;
  type: string;
  description: string | null;
  updatedAt: string;
}

const settingsSchema = z.object({
  // Site Information
  site_name: z.string().min(1, "Site name is required"),
  site_tagline: z.string().min(1, "Site tagline is required"),
  site_logo: z.string().optional(),

  // Store Information
  store_email: z.string().email("Valid email is required"),
  store_phone: z.string().min(1, "Phone number is required"),
  store_address: z.string().min(1, "Address is required"),
  store_city: z.string().min(1, "City is required"),
  store_state: z.string().min(1, "State is required"),
  store_zip: z.string().min(1, "ZIP code is required"),
  store_country: z.string().min(1, "Country is required"),

  // Social Media Links
  social_facebook: z
    .string()
    .url("Valid URL required")
    .optional()
    .or(z.literal("")),
  social_instagram: z
    .string()
    .url("Valid URL required")
    .optional()
    .or(z.literal("")),
  social_twitter: z
    .string()
    .url("Valid URL required")
    .optional()
    .or(z.literal("")),
  social_linkedin: z
    .string()
    .url("Valid URL required")
    .optional()
    .or(z.literal("")),
  social_youtube: z
    .string()
    .url("Valid URL required")
    .optional()
    .or(z.literal("")),
  social_website: z
    .string()
    .url("Valid URL required")
    .optional()
    .or(z.literal("")),
});

type SettingsFormData = z.infer<typeof settingsSchema>;

export default function AdminSettings() {
  const { toast } = useToast();
  const [logoFile, setLogoFile] = React.useState<File | null>(null);
  const [logoPreview, setLogoPreview] = React.useState<string | null>(null);
  const [isUploadingLogo, setIsUploadingLogo] = React.useState(false);

  const { data: settings = [], isLoading } = useQuery({
    queryKey: ["/api/admin/site-settings"],
    queryFn: async () => {
      try {
        // Try admin endpoint first
        return await apiRequest("/api/admin/site-settings");
      } catch (error) {
        // Fallback to public endpoint if admin auth fails
        console.warn("Admin endpoint failed, falling back to public endpoint");
        return await apiRequest("/api/site-settings");
      }
    },
    refetchOnMount: "always",
    staleTime: 0,
  });

  // Transform settings array to object for form
  const settingsMap = React.useMemo(() => {
    return settings.reduce(
      (acc: Record<string, string>, setting: SiteSetting) => {
        acc[setting.key] = setting.value || "";
        return acc;
      },
      {}
    );
  }, [settings]);

  const form = useForm<SettingsFormData>({
    resolver: zodResolver(settingsSchema),
    defaultValues: settingsMap,
  });

  React.useEffect(() => {
    if (settingsMap && Object.keys(settingsMap).length > 0) {
      // Create a clean settings object for form
      const cleanSettings = { ...settingsMap };

      // For uploaded images (not external URLs), clear the site_logo field in form
      if (
        settingsMap.site_logo &&
        (settingsMap.site_logo.startsWith("/uploads/") ||
          settingsMap.site_logo.includes("@fs"))
      ) {
        cleanSettings.site_logo = "";
      }

      form.reset(cleanSettings);
      // Set logo preview if there's an existing logo
      if (settingsMap.site_logo) {
        setLogoPreview(settingsMap.site_logo);
      }
    }
  }, [settingsMap, form]);

  const handleLogoUpload = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (file) {
      if (!file.type.startsWith("image/")) {
        toast({
          title: "Invalid file type",
          description: "Please select an image file.",
          variant: "destructive",
        });
        return;
      }

      if (file.size > 6 * 1024 * 1024) {
        // 5MB limit
        toast({
          title: "File too large",
          description: "Please select an image smaller than 5MB.",
          variant: "destructive",
        });
        return;
      }

      setLogoFile(file);

      // Create preview URL
      const reader = new FileReader();
      reader.onload = (e) => {
        setLogoPreview(e.target?.result as string);
      };
      reader.readAsDataURL(file);

      // Clear the URL field when uploading a file
      form.setValue("site_logo", "");
    }
  };

  const removeLogo = async () => {
    try {
      // First, delete the image file from server if it's an uploaded file
      const currentLogo = settingsMap.site_logo;
      if (currentLogo && (currentLogo.startsWith("/uploads/") || currentLogo.includes("@fs"))) {
        try {
          await apiRequest("/api/images/delete/product-image", {
            method: "DELETE",
            body: JSON.stringify({ imagePath: currentLogo }),
          });
        } catch (error) {
          console.warn("Failed to delete image file:", error);
          // Continue with removing from database even if file deletion fails
        }
      }

      // Update the database to remove the logo setting
      await updateSettingMutation.mutateAsync([
        {
          key: "site_logo",
          value: "",
          type: "text",
          description: "Website logo URL",
        },
      ]);

      // Clear local state
      setLogoFile(null);
      setLogoPreview(null);
      form.setValue("site_logo", "");
      
      // Reset the file input
      const fileInput = document.getElementById("logo-upload") as HTMLInputElement;
      if (fileInput) {
        fileInput.value = "";
      }

      toast({
        title: "Logo removed",
        description: "The site logo has been removed successfully.",
      });
    } catch (error) {
      toast({
        title: "Error",
        description: "Failed to remove logo. Please try again.",
        variant: "destructive",
      });
    }
  };

  const updateSettingMutation = useMutation({
    mutationFn: (
      settings: Array<{
        key: string;
        value: string;
        type: string;
        description?: string;
      }>
    ) =>
      apiRequest("/api/admin/site-settings", {
        method: "POST",
        body: JSON.stringify(settings), // Send all at once
      }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/admin/site-settings"] });
      queryClient.invalidateQueries({ queryKey: ["/api/site-settings"] });
    },
  });

  const onSubmit = async (data: SettingsFormData) => {
    try {
      let logoUrl = data.site_logo;

      // If there's a new logo file to upload
      if (logoFile) {
        setIsUploadingLogo(true);
        const formData = new FormData();
        formData.append("image", logoFile);

        const uploadResponse = await fetch("/api/images/upload/product-image", {
          method: "POST",
          body: formData,
        });

        if (!uploadResponse.ok) {
          if (uploadResponse.status === 413) {
            throw new Error(
              "Logo file size too large. Maximum file size is 5MB."
            );
          } else {
            throw new Error(
              `Failed to upload logo (Status: ${uploadResponse.status})`
            );
          }
        }

        const uploadData = await uploadResponse.json();
        logoUrl = uploadData.imagePath;

        // Update the form field with the uploaded image path
        form.setValue("site_logo", logoUrl);

        toast({
          title: "Logo uploaded successfully",
          description: "Your site logo has been uploaded and will be updated.",
        });

        setIsUploadingLogo(false);
      }

      const updates = Object.entries({ ...data, site_logo: logoUrl }).map(
        ([key, value]) => ({
          key,
          value: value || "",
          type: "text",
          description: getSettingDescription(key),
        })
      );

      await updateSettingMutation.mutateAsync(updates);

      // Clear the logo file after successful save
      setLogoFile(null);

      toast({
        title: "Settings Updated",
        description: "Store settings have been saved successfully.",
        variant: "default",
      });
    } catch (error) {
      setIsUploadingLogo(false);
      toast({
        title: "Error",
        description: "Failed to update settings. Please try again.",
        variant: "destructive",
      });
    }
  };

  const getSettingDescription = (key: string): string => {
    const descriptions: Record<string, string> = {
      site_name: "Website name",
      site_tagline: "Website tagline",
      site_logo: "Website logo URL",
      store_email: "Store contact email",
      store_phone: "Store contact phone",
      store_address: "Store address",
      store_city: "Store city",
      store_state: "Store state",
      store_zip: "Store zip code",
      store_country: "Store country",
      social_facebook: "Facebook page URL",
      social_instagram: "Instagram profile URL",
      social_twitter: "Twitter profile URL",
      social_linkedin: "LinkedIn company page URL",
      social_youtube: "YouTube channel URL",
      social_website: "Official website URL",
    };
    return descriptions[key] || "";
  };

  if (isLoading) {
    return <MainLoader />;
  }

  return (
    <div className="container">
      <div className="mb-6">
        <h1 className="text-3xl font-bold">Store Settings</h1>
        <p className="text-muted-foreground mt-2">
          Manage your store information and social media links
        </p>
      </div>

      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
        {/* Site Information */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Globe className="h-5 w-5" />
              Site Information
            </CardTitle>
            <CardDescription>
              Basic information about your website
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <Label htmlFor="site_name">Site Name</Label>
                <Input
                  id="site_name"
                  {...form.register("site_name")}
                  placeholder="HarvestDirect"
                />
                {form.formState.errors.site_name && (
                  <p className="text-sm text-destructive mt-1">
                    {form.formState.errors.site_name.message}
                  </p>
                )}
              </div>
              <div>
                <Label htmlFor="site_tagline">Site Tagline</Label>
                <Input
                  id="site_tagline"
                  {...form.register("site_tagline")}
                  placeholder="Fresh from Farm to Your Table"
                />
                {form.formState.errors.site_tagline && (
                  <p className="text-sm text-destructive mt-1">
                    {form.formState.errors.site_tagline.message}
                  </p>
                )}
              </div>
            </div>
            <div className="space-y-4">
              <Label>Site Logo (Optional)</Label>

              {/* Logo Preview - Show only when there's actual logo data and it hasn't been explicitly removed */}
              {(logoPreview || 
                (settingsMap.site_logo && form.watch("site_logo") !== "") ||
                form.watch("site_logo")) ? (
                <div className="flex items-center gap-4 p-4 border rounded-lg bg-gray-50 dark:bg-gray-800">
                  <div className="relative w-16 h-16 flex-shrink-0">
                    <img
                      src={
                        logoPreview ||
                        form.watch("site_logo") ||
                        getImageUrl(settingsMap.site_logo) ||
                        placeholderImage
                      }
                      alt="Logo preview"
                      className="w-full h-full object-contain border rounded"
                      onLoad={() => {
                        // Logo loaded successfully
                      }}
                      onError={(e) => {
                        console.warn(
                          "Logo failed to load, using placeholder:",
                          logoPreview ||
                            form.watch("site_logo") ||
                            getImageUrl(settingsMap.site_logo)
                        );
                        e.currentTarget.onerror = null;
                        e.currentTarget.src = placeholderImage;
                      }}
                    />
                  </div>
                  <div className="flex-1">
                    <p className="text-sm font-medium">Site Logo</p>
                    <p className="text-xs text-muted-foreground">
                      {logoFile
                        ? "New upload pending save"
                        : form.watch("site_logo")
                        ? "URL provided"
                        : "Currently active"}
                    </p>
                    {(form.watch("site_logo") || settingsMap.site_logo) && (
                      <p className="text-xs text-muted-foreground mt-1 truncate">
                        {(() => {
                          const currentUrl =
                            form.watch("site_logo") || settingsMap.site_logo;
                          // Don't show local file system paths or uploaded image paths
                          if (
                            currentUrl &&
                            !currentUrl.includes("@fs") &&
                            !currentUrl.startsWith("/uploads/") &&
                            !currentUrl.startsWith("/@fs")
                          ) {
                            return currentUrl;
                          }
                          return "Uploaded image";
                        })()}
                      </p>
                    )}
                  </div>
                  <Button
                    type="button"
                    variant="outline"
                    size="sm"
                    onClick={removeLogo}
                    className="text-destructive hover:bg-destructive/10"
                  >
                    <X className="h-4 w-4" />
                  </Button>
                </div>
              ) : null}

              {/* Upload Options */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <Label htmlFor="logo-upload" className="text-sm font-medium">
                    Upload New Logo
                  </Label>
                  <div className="mt-1">
                    <input
                      id="logo-upload"
                      type="file"
                      accept="image/*"
                      onChange={handleLogoUpload}
                      className="hidden"
                    />
                    <Button
                      type="button"
                      variant="outline"
                      onClick={() =>
                        document.getElementById("logo-upload")?.click()
                      }
                      className="w-full justify-center"
                    >
                      <Upload className="h-4 w-4 mr-2" />
                      Choose Image
                    </Button>
                  </div>
                  <p className="text-xs text-muted-foreground mt-1">
                    PNG, JPG, WebP up to 5MB. Recommended: 200x200px
                  </p>
                </div>

                <div>
                  <Label htmlFor="site_logo">Or Enter URL</Label>
                  <Input
                    id="site_logo"
                    {...form.register("site_logo")}
                    placeholder="https://example.com/logo.png"
                    className="mt-1"
                  />
                  <p className="text-xs text-muted-foreground mt-1">
                    Direct link to your logo image
                  </p>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Store Information */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Store className="h-5 w-5" />
              Store Information
            </CardTitle>
            <CardDescription>
              Contact details and address information
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <Label htmlFor="store_email">Email</Label>
                <Input
                  id="store_email"
                  type="email"
                  {...form.register("store_email")}
                  placeholder="contact@harvestdirect.com"
                />
                {form.formState.errors.store_email && (
                  <p className="text-sm text-destructive mt-1">
                    {form.formState.errors.store_email.message}
                  </p>
                )}
              </div>
              <div>
                <Label htmlFor="store_phone">Phone</Label>
                <Input
                  id="store_phone"
                  {...form.register("store_phone")}
                  placeholder="+91 98765 43210"
                />
                {form.formState.errors.store_phone && (
                  <p className="text-sm text-destructive mt-1">
                    {form.formState.errors.store_phone.message}
                  </p>
                )}
              </div>
            </div>

            <div>
              <Label htmlFor="store_address">Address</Label>
              <Input
                id="store_address"
                {...form.register("store_address")}
                placeholder="123, Brigade Road, MG Road"
              />
              {form.formState.errors.store_address && (
                <p className="text-sm text-destructive mt-1">
                  {form.formState.errors.store_address.message}
                </p>
              )}
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div>
                <Label htmlFor="store_city">City</Label>
                <Input
                  id="store_city"
                  {...form.register("store_city")}
                  placeholder="Farmington"
                />
                {form.formState.errors.store_city && (
                  <p className="text-sm text-destructive mt-1">
                    {form.formState.errors.store_city.message}
                  </p>
                )}
              </div>
              <div>
                <Label htmlFor="store_state">State</Label>
                <Input
                  id="store_state"
                  {...form.register("store_state")}
                  placeholder="Karnataka"
                />
                {form.formState.errors.store_state && (
                  <p className="text-sm text-destructive mt-1">
                    {form.formState.errors.store_state.message}
                  </p>
                )}
              </div>
              <div>
                <Label htmlFor="store_zip">ZIP Code</Label>
                <Input
                  id="store_zip"
                  {...form.register("store_zip")}
                  placeholder="90210"
                />
                {form.formState.errors.store_zip && (
                  <p className="text-sm text-destructive mt-1">
                    {form.formState.errors.store_zip.message}
                  </p>
                )}
              </div>
            </div>

            <div>
              <Label htmlFor="store_country">Country</Label>
              <Input
                id="store_country"
                {...form.register("store_country")}
                placeholder="United States"
              />
              {form.formState.errors.store_country && (
                <p className="text-sm text-destructive mt-1">
                  {form.formState.errors.store_country.message}
                </p>
              )}
            </div>
          </CardContent>
        </Card>

        {/* Social Media Links */}
        <Card>
          <CardHeader>
            <CardTitle>Social Media Links</CardTitle>
            <CardDescription>
              Connect your social media profiles (all optional)
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <Label htmlFor="social_facebook">Facebook</Label>
                <Input
                  id="social_facebook"
                  {...form.register("social_facebook")}
                  placeholder="https://facebook.com/harvestdirect"
                />
                {form.formState.errors.social_facebook && (
                  <p className="text-sm text-destructive mt-1">
                    {form.formState.errors.social_facebook.message}
                  </p>
                )}
              </div>
              <div>
                <Label htmlFor="social_instagram">Instagram</Label>
                <Input
                  id="social_instagram"
                  {...form.register("social_instagram")}
                  placeholder="https://instagram.com/harvestdirect"
                />
                {form.formState.errors.social_instagram && (
                  <p className="text-sm text-destructive mt-1">
                    {form.formState.errors.social_instagram.message}
                  </p>
                )}
              </div>
              <div>
                <Label htmlFor="social_twitter">Twitter</Label>
                <Input
                  id="social_twitter"
                  {...form.register("social_twitter")}
                  placeholder="https://twitter.com/harvestdirect"
                />
                {form.formState.errors.social_twitter && (
                  <p className="text-sm text-destructive mt-1">
                    {form.formState.errors.social_twitter.message}
                  </p>
                )}
              </div>
              <div>
                <Label htmlFor="social_linkedin">LinkedIn</Label>
                <Input
                  id="social_linkedin"
                  {...form.register("social_linkedin")}
                  placeholder="https://linkedin.com/company/harvestdirect"
                />
                {form.formState.errors.social_linkedin && (
                  <p className="text-sm text-destructive mt-1">
                    {form.formState.errors.social_linkedin.message}
                  </p>
                )}
              </div>
              <div>
                <Label htmlFor="social_youtube">YouTube</Label>
                <Input
                  id="social_youtube"
                  {...form.register("social_youtube")}
                  placeholder="https://youtube.com/@harvestdirect"
                />
                {form.formState.errors.social_youtube && (
                  <p className="text-sm text-destructive mt-1">
                    {form.formState.errors.social_youtube.message}
                  </p>
                )}
              </div>
              <div>
                <Label htmlFor="social_website">Website</Label>
                <Input
                  id="social_website"
                  {...form.register("social_website")}
                  placeholder="https://harvestdirect.com"
                />
                {form.formState.errors.social_website && (
                  <p className="text-sm text-destructive mt-1">
                    {form.formState.errors.social_website.message}
                  </p>
                )}
              </div>
            </div>
          </CardContent>
        </Card>

        <div className="flex justify-between">
          <Button
            type="submit"
            disabled={updateSettingMutation.isPending || isUploadingLogo}
            className="min-w-[120px]"
          >
            {updateSettingMutation.isPending || isUploadingLogo ? (
              <div className="flex items-center">
                <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white mr-2"></div>
                {isUploadingLogo ? "Uploading Logo..." : "Saving..."}
              </div>
            ) : (
              <>
                <Save className="h-4 w-4 mr-2" />
                Save Settings
              </>
            )}
          </Button>
        </div>
      </form>
    </div>
  );
}
