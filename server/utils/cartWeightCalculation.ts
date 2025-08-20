import { db } from "../db";
import { eq, sql } from "drizzle-orm";
import { cartItems, productVariants } from "../../shared/schema";
import { calculateShippingCost } from "./weightCalculation";

/**
 * Calculate total weight for all items in a cart
 * @param cartId - Cart ID
 * @returns Promise with total weight in kg
 */
export async function calculateCartTotalWeight(cartId: number): Promise<number> {
  try {
    // Query to get total weight by joining cart_items with product_variants
    const result = await db
      .select({
        totalWeight: sql<number>`COALESCE(SUM(${cartItems.quantity} * ${productVariants.weight}), 0)`
      })
      .from(cartItems)
      .innerJoin(productVariants, eq(cartItems.variantId, productVariants.id))
      .where(eq(cartItems.cartId, cartId));

    return result[0]?.totalWeight || 0;
  } catch (error) {
    console.error(`Error calculating total weight for cart ${cartId}:`, error);
    return 0;
  }
}

/**
 * Calculate cart weight and shipping cost
 * @param cartId - Cart ID
 * @returns Promise with weight and shipping cost details
 */
export async function calculateCartWeightAndShipping(cartId: number): Promise<{
  totalWeight: number;
  shippingCost: number;
  success: boolean;
}> {
  try {
    // Calculate total weight
    const totalWeight = await calculateCartTotalWeight(cartId);
    
    // Calculate shipping cost based on weight
    const shippingCost = calculateShippingCost(totalWeight);

    console.log(`Cart ${cartId} calculated: Weight=${totalWeight}kg, Shipping=₹${shippingCost}`);

    return {
      totalWeight,
      shippingCost,
      success: true
    };
  } catch (error) {
    console.error(`Error calculating cart weight for cart ${cartId}:`, error);
    return {
      totalWeight: 0,
      shippingCost: 0,
      success: false
    };
  }
}