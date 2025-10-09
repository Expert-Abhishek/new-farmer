import { db } from "../db";
import { eq, sql } from "drizzle-orm";
import { cartItems, productVariants } from "../../shared/schema";
import { calculateShippingCost, convertToKilograms } from "./weightCalculation";

/**
 * Calculate total weight for all items in a cart
 * @param cartId - Cart ID
 * @returns Promise with total weight in kg
 */
export async function calculateCartTotalWeight(cartId: number): Promise<number> {
  try {
    // Query to get all cart items with their weights and units
    const items = await db
      .select({
        quantity: cartItems.quantity,
        weight: productVariants.weight,
        unit: productVariants.unit
      })
      .from(cartItems)
      .innerJoin(productVariants, eq(cartItems.variantId, productVariants.id))
      .where(eq(cartItems.cartId, cartId));

    // Calculate total weight by converting each item to kg
    let totalWeightKg = 0;
   
    for (const item of items) {
      const weightInKg = convertToKilograms(item.weight || 0, item.unit || 'kg');
      totalWeightKg += item.quantity * weightInKg;
    }

    console.log(`Cart ${cartId} total weight calculation: ${totalWeightKg}kg`);
    return totalWeightKg;
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