import { db } from "../db.js";
import { eq, sql } from "drizzle-orm";
import { orders, orderItems, productVariants } from "../../shared/schema.ts";

/**
 * Calculate shipping cost based on weight
 * @param weightInKg - Total weight in kilograms
 * @returns Shipping cost in rupees
 */
export function calculateShippingCost(weightInKg: number): number {
  if (weightInKg <= 0) return 0;
  
  if (weightInKg <= 0.5) {
    return 45; // Below 0.5kg = ₹45
  } else if (weightInKg <= 1.0) {
    return 82; // 0.5kg to 1kg = ₹82
  } else {
    // For weights above 1kg, you might want to add more tiers
    // For now, let's assume ₹82 + ₹50 for each additional 0.5kg
    const additionalWeight = weightInKg - 1.0;
    const additionalCost = Math.ceil(additionalWeight / 0.5) * 50;
    return 82 + additionalCost;
  }
}

/**
 * Calculate total weight for an order
 * @param orderId - Order ID
 * @returns Promise with total weight in kg
 */
export async function calculateOrderTotalWeight(orderId: number): Promise<number> {
  try {
    // Query to get total weight by joining order_items with product_variants
    const result = await db
      .select({
        totalWeight: sql<number>`COALESCE(SUM(${orderItems.quantity} * ${productVariants.weight}), 0)`
      })
      .from(orderItems)
      .innerJoin(productVariants, eq(orderItems.variantId, productVariants.id))
      .where(eq(orderItems.orderId, orderId));

    return result[0]?.totalWeight || 0;
  } catch (error) {
    console.error(`Error calculating total weight for order ${orderId}:`, error);
    return 0;
  }
}

/**
 * Update order's total weight and shipping cost
 * @param orderId - Order ID
 * @returns Promise with updated weight and shipping cost
 */
export async function updateOrderWeightAndShipping(orderId: number): Promise<{
  totalWeight: number;
  shippingCost: number;
  success: boolean;
}> {
  try {
    // Calculate total weight
    const totalWeight = await calculateOrderTotalWeight(orderId);
    
    // Calculate shipping cost based on weight
    const shippingCost = calculateShippingCost(totalWeight);

    // Update the order with new weight and shipping cost
    await db
      .update(orders)
      .set({
        totalWeight,
        shippingCost,
        updatedAt: new Date()
      })
      .where(eq(orders.id, orderId));

    console.log(`Order ${orderId} updated: Weight=${totalWeight}kg, Shipping=₹${shippingCost}`);

    return {
      totalWeight,
      shippingCost,
      success: true
    };
  } catch (error) {
    console.error(`Error updating weight for order ${orderId}:`, error);
    return {
      totalWeight: 0,
      shippingCost: 0,
      success: false
    };
  }
}

/**
 * Recalculate weight for all orders (useful for migration or bulk updates)
 * @param orderIds - Optional array of specific order IDs to update
 * @returns Promise with results
 */
export async function recalculateOrderWeights(orderIds?: number[]): Promise<{
  updated: number;
  errors: number;
}> {
  try {
    let ordersToUpdate: { id: number }[];

    if (orderIds && orderIds.length > 0) {
      // Update specific orders
      ordersToUpdate = orderIds.map(id => ({ id }));
    } else {
      // Get all order IDs
      ordersToUpdate = await db.select({ id: orders.id }).from(orders);
    }

    let updated = 0;
    let errors = 0;

    for (const order of ordersToUpdate) {
      const result = await updateOrderWeightAndShipping(order.id);
      if (result.success) {
        updated++;
      } else {
        errors++;
      }
    }

    console.log(`Bulk weight recalculation completed: ${updated} updated, ${errors} errors`);

    return { updated, errors };
  } catch (error) {
    console.error('Error in bulk weight recalculation:', error);
    return { updated: 0, errors: 1 };
  }
}