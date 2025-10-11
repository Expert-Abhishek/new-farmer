import { db } from "../db.js";
import { eq, sql } from "drizzle-orm";
import { orders, orderItems, productVariants } from "../../shared/schema.ts";

/**
 * Convert weight to kilograms based on unit
 * @param weight - Weight value
 * @param unit - Unit (g, l, kg)
 * @returns Weight in kilograms
 */
export function convertToKilograms(weight: number, unit: string): number {
  console.log('>>>>>>>check',unit,weight);
  switch (unit.toLowerCase()) {
    case 'g': // grams to kg
      return weight / 1000;
    case 'l': // liters treated same as kg for shipping
    case 'kg': // already in kg
      return weight;
    default:
      console.warn(`Unknown unit: ${unit}, treating as kg`);
      return weight;
  }
}

/**
 * Calculate shipping cost based on weight
 * @param weightInKg - Total weight in kilograms
 * @returns Shipping cost in rupees
 */
export function calculateShippingCost(weightInKg: number): number {
  if (weightInKg <= 0) return 0;

  if (weightInKg <= 0.2) {
    return 50; // 0 to 200g
  } else if (weightInKg <= 0.5) {
    return 70; // 200g to 500g
  } else if (weightInKg <= 2.0) {
    return 100; // 500g to 2kg
  } else {
    // Above 2kg: ₹100 + ₹40 per full additional kg
    const additionalKgs = Math.floor(weightInKg - 2); // ignore grams
    const additionalCost = additionalKgs * 40;
    return 100 + additionalCost;
  }
}

/**
 * Calculate total weight for an order
 * @param orderId - Order ID
 * @returns Promise with total weight in kg
 */
export async function calculateOrderTotalWeight(orderId: number): Promise<number> {
  try {
    // Query to get all items with their weights and units
    const items = await db
      .select({
        quantity: orderItems.quantity,
        weight: productVariants.weight,
        unit: productVariants.unit
      })
      .from(orderItems)
      .innerJoin(productVariants, eq(orderItems.variantId, productVariants.id))
      .where(eq(orderItems.orderId, orderId));

    // Calculate total weight by converting each item to kg
    let totalWeightKg = 0;
    for (const item of items) {
      const weightInKg = convertToKilograms(item.weight || 0, item.unit || 'kg');
      totalWeightKg += item.quantity * weightInKg;
    }

    return totalWeightKg;
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