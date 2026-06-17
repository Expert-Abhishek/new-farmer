import { useState, useEffect, ReactNode } from 'react';
import { useLocation } from 'wouter';
import { useToast } from '@/hooks/use-toast';

interface AdminAuthWrapperProps {
  children: ReactNode;
}

export default function AdminAuthWrapper({ children }: AdminAuthWrapperProps) {
  const [, setLocation] = useLocation();
  const { toast } = useToast();
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const checkAuth = async () => {
      const token = localStorage.getItem('adminToken');
      
      if (!token) {
        setIsAuthenticated(false);
        setIsLoading(false);
        setLocation('/admin/login');
        return;
      }

      // For initial page load or refresh, assume token is valid if it exists
      // Only verify on actual authentication actions, not on every page refresh
      setIsAuthenticated(true);
      setIsLoading(false);
      
      // Optional: Silently verify token in background without redirecting
      try {
        const response = await fetch( `${import.meta.env.VITE_API_URL}/api/admin/dashboard`, {
          headers: {
            'Authorization': `Bearer ${token}`
          }
        });

        if (!response.ok) {
          // Token is invalid but don't redirect immediately
          // Let the user continue but clear invalid token
          localStorage.removeItem('adminToken');
          localStorage.removeItem('adminUser');
        }
      } catch (error) {
        // Network error or server issue - don't redirect, just log
        console.warn('Token verification failed (network/server issue):', error);
      }
    };

    checkAuth();
  }, [setLocation, toast]);

  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50 dark:bg-gray-900">
        <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-primary"></div>
      </div>
    );
  }

  if (!isAuthenticated) {
    return null; // Will redirect in the useEffect
  }

  return <>{children}</>;
}