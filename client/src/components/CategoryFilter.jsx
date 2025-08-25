import { useState, useEffect } from "react";
import { useQuery } from "@tanstack/react-query";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Label } from "@/components/ui/label";
import ProductCard from "@/components/ProductCard";
import MainLoader from "@/utils/MainLoader";

export default function CategoryFilter() {
  // State management
  const [selectedCategoryId, setSelectedCategoryId] = useState("");
  const [selectedSubcategoryId, setSelectedSubcategoryId] = useState("");
  const [filteredProducts, setFilteredProducts] = useState([]);

  // Fetch all products
  const { data: productsResponse, isLoading: productsLoading } = useQuery({
    queryKey: [`${import.meta.env.VITE_API_URL}/api/products`, "all"],
    queryFn: async () => {
      const response = await fetch(
        `${import.meta.env.VITE_API_URL}/api/products?limit=1000`
      );
      if (!response.ok) {
        throw new Error(`Failed to fetch products: ${response.status}`);
      }
      return response.json();
    },
  });

  // Fetch categories
  const { data: categories = [], isLoading: categoriesLoading } = useQuery({
    queryKey: [`${import.meta.env.VITE_API_URL}/api/categories/main`],
    queryFn: async () => {
      const response = await fetch(
        `${import.meta.env.VITE_API_URL}/api/categories/main`
      );
      if (!response.ok) {
        throw new Error(`Failed to fetch categories: ${response.status}`);
      }
      return response.json();
    },
  });

  // Fetch subcategories for selected category
  const { data: subcategories = [] } = useQuery({
    queryKey: [
      `${import.meta.env.VITE_API_URL}/api/categories`,
      selectedCategoryId,
      "subcategories",
    ],
    queryFn: async () => {
      if (!selectedCategoryId) return [];
      const response = await fetch(
        `${import.meta.env.VITE_API_URL}/api/categories/${selectedCategoryId}/subcategories`
      );
      if (!response.ok) {
        throw new Error(`Failed to fetch subcategories: ${response.status}`);
      }
      return response.json();
    },
    enabled: !!selectedCategoryId,
  });

  const allProducts = productsResponse?.products || [];

  // Filter products based on selected category and subcategory
  useEffect(() => {
    let filtered = [...allProducts];

    if (selectedCategoryId) {
      const selectedCategory = categories.find(
        (cat) => cat.id.toString() === selectedCategoryId
      );
      if (selectedCategory) {
        filtered = filtered.filter(
          (product) => product.category === selectedCategory.name
        );
      }
    }

    if (selectedSubcategoryId) {
      const selectedSubcategory = subcategories.find(
        (subcat) => subcat.id.toString() === selectedSubcategoryId
      );
      if (selectedSubcategory) {
        filtered = filtered.filter(
          (product) => product.subcategory === selectedSubcategory.name
        );
      }
    }

    setFilteredProducts(filtered);
  }, [allProducts, selectedCategoryId, selectedSubcategoryId, categories, subcategories]);

  // Handle category change
  const handleCategoryChange = (categoryId) => {
    setSelectedCategoryId(categoryId);
    setSelectedSubcategoryId(""); // Reset subcategory when category changes
  };

  // Handle subcategory change
  const handleSubcategoryChange = (subcategoryId) => {
    setSelectedSubcategoryId(subcategoryId);
  };

  if (productsLoading || categoriesLoading) {
    return <MainLoader />;
  }

  return (
    <div className="bg-background py-16 min-h-screen">
      <div className="container mx-auto px-4">
        <div className="text-center mb-12">
          <h1 className="font-heading text-forest text-2xl sm:text-3xl md:text-4xl font-bold mb-4">
            Product Filter
          </h1>
          <p className="text-olive text-base sm:text-lg max-w-2xl mx-auto">
            Use the dropdown filters below to find products by category and subcategory.
          </p>
        </div>

        {/* Filter Dropdowns */}
        <div className="bg-white p-6 rounded-lg shadow-sm mb-8 max-w-4xl mx-auto">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {/* Category Dropdown */}
            <div>
              <Label className="text-foreground font-medium mb-2 block">
                Select Category
              </Label>
              <Select
                value={selectedCategoryId}
                onValueChange={handleCategoryChange}
              >
                <SelectTrigger>
                  <SelectValue placeholder="All Categories" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="">All Categories</SelectItem>
                  {categories.map((category) => (
                    <SelectItem key={category.id} value={category.id.toString()}>
                      {category.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            {/* Subcategory Dropdown */}
            <div>
              <Label className="text-foreground font-medium mb-2 block">
                Select Subcategory
              </Label>
              <Select
                value={selectedSubcategoryId}
                onValueChange={handleSubcategoryChange}
                disabled={!selectedCategoryId || subcategories.length === 0}
              >
                <SelectTrigger>
                  <SelectValue placeholder="All Subcategories" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="">All Subcategories</SelectItem>
                  {subcategories.map((subcategory) => (
                    <SelectItem key={subcategory.id} value={subcategory.id.toString()}>
                      {subcategory.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          </div>

          {/* Filter Summary */}
          <div className="mt-4 text-center">
            <p className="text-sm text-muted-foreground">
              Showing {filteredProducts.length} products
              {selectedCategoryId && (
                <span>
                  {" "}
                  in {categories.find((cat) => cat.id.toString() === selectedCategoryId)?.name}
                </span>
              )}
              {selectedSubcategoryId && (
                <span>
                  {" "}
                  - {subcategories.find((subcat) => subcat.id.toString() === selectedSubcategoryId)?.name}
                </span>
              )}
            </p>
          </div>
        </div>

        {/* Products Grid */}
        <div className="max-w-7xl mx-auto">
          {filteredProducts.length === 0 ? (
            <div className="text-center py-12">
              <p className="text-muted-foreground text-lg">
                No products found matching your filters.
              </p>
              <button
                onClick={() => {
                  setSelectedCategoryId("");
                  setSelectedSubcategoryId("");
                }}
                className="mt-4 px-6 py-2 bg-primary text-white rounded-lg hover:bg-primary/90 transition-colors"
              >
                Clear Filters
              </button>
            </div>
          ) : (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
              {filteredProducts.map((product) => (
                <div key={product.id} className="scroll-animation">
                  <ProductCard product={product} />
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}