import { ArrowRight, Package, RefreshCw, Truck, AlertCircle } from "lucide-react";

export default function ShippingReturns() {
  return (
    <div className="bg-background min-h-screen pt-24 pb-16">
      <div className="container mx-auto px-4 lg:px-8">
        <div className="max-w-4xl mx-auto">
          {/* Page Header */}
          <div className="text-center mb-12">
            <h1 className="font-heading text-forest text-4xl md:text-5xl font-bold mb-4">Shipping & Returns</h1>
            <p className="text-olive text-lg max-w-2xl mx-auto">
              Information about our shipping process, delivery timeframes, and return policy.
            </p>
          </div>

          {/* Shipping Information */}
          <div className="bg-white shadow-md rounded-lg p-6 md:p-8 mb-8">
            <div className="flex items-center mb-6">
              <div className="bg-primary/10 p-3 rounded-full mr-4">
                <Truck className="text-primary h-6 w-6" />
              </div>
              <h2 className="font-heading text-forest text-2xl font-bold">Shipping Information</h2>
            </div>

            <div className="space-y-6">
              <div className="border-b border-gray-200 pb-6">
                <h3 className="font-heading text-forest text-xl font-semibold mb-3">Shipping Methods & Timeframes</h3>
                <p className="text-olive mb-4">
                  We partner with Indian Post to deliver your farm-fresh products safely and affordably across India:
                </p>
                <ul className="space-y-3">
                  <li className="flex">
                    <ArrowRight className="text-primary h-5 w-5 mt-0.5 mr-2 flex-shrink-0" />
                    <div>
                      <span className="font-medium text-forest">Standard Delivery via Indian Post (5-7 business days):</span>
                      <p className="text-olive">Reliable nationwide delivery service</p>
                    </div>
                  </li>
                </ul>

                <div className="mt-6">
                  <h4 className="font-heading text-forest text-lg font-semibold mb-3">Shipping Charges Based on Weight</h4>
                  <div className="bg-gray-50 rounded-lg p-4">
                    <div className="grid gap-3">
                      <div className="flex justify-between items-center py-2 border-b border-gray-200">
                        <span className="text-forest font-medium">0 - 200 grams</span>
                        <span className="text-olive">₹50</span>
                      </div>
                      <div className="flex justify-between items-center py-2 border-b border-gray-200">
                        <span className="text-forest font-medium">200 grams - 500 grams</span>
                        <span className="text-olive">₹70</span>
                      </div>
                      <div className="flex justify-between items-center py-2 border-b border-gray-200">
                        <span className="text-forest font-medium">500 grams - 2 kg</span>
                        <span className="text-olive">₹100</span>
                      </div>
                      <div className="flex justify-between items-center py-2">
                        <span className="text-forest font-medium">Above 2 kg</span>
                        <span className="text-olive">₹100 + ₹40 per additional kg</span>
                      </div>
                    </div>
                  </div>
                  <p className="text-sm text-olive mt-3">
                    <span className="font-medium text-forest">Note:</span> Shipping charges are calculated automatically based on the total weight of your order during checkout.
                  </p>
                </div>
              </div>

              <div className="border-b border-gray-200 pb-6">
                <h3 className="font-heading text-forest text-xl font-semibold mb-3">Delivery Areas</h3>
                <p className="text-olive mb-4">
                  We currently deliver to most locations across India. Delivery timeframes and options may vary based on your location.
                </p>
                <p className="text-olive">
                  Standard shipping is available nationwide, while express and same-day options are limited to major cities and surrounding areas. During checkout, you'll see available shipping options for your specific location.
                </p>
              </div>

              <div className="border-b border-gray-200 pb-6">
                <h3 className="font-heading text-forest text-xl font-semibold mb-3">Packaging</h3>
                <p className="text-olive mb-4">
                  We take special care in packaging your products to ensure they arrive fresh and undamaged:
                </p>
                <ul className="space-y-3">
                  <li className="flex">
                    <ArrowRight className="text-primary h-5 w-5 mt-0.5 mr-2 flex-shrink-0" />
                    <div>
                      <span className="font-medium text-forest">Perishable Items:</span>
                      <p className="text-olive">Packed with eco-friendly insulation and ice packs to maintain optimal temperature</p>
                    </div>
                  </li>
                  <li className="flex">
                    <ArrowRight className="text-primary h-5 w-5 mt-0.5 mr-2 flex-shrink-0" />
                    <div>
                      <span className="font-medium text-forest">Fragile Items:</span>
                      <p className="text-olive">Carefully cushioned with biodegradable protective materials</p>
                    </div>
                  </li>
                  <li className="flex">
                    <ArrowRight className="text-primary h-5 w-5 mt-0.5 mr-2 flex-shrink-0" />
                    <div>
                      <span className="font-medium text-forest">Eco-Friendly Approach:</span>
                      <p className="text-olive">We use minimal, recyclable, and biodegradable packaging materials wherever possible</p>
                    </div>
                  </li>
                </ul>
              </div>

              <div>
                <h3 className="font-heading text-forest text-xl font-semibold mb-3">Order Tracking</h3>
                <p className="text-olive mb-4">
                  Once your order ships, you'll receive a tracking number via email and SMS. You can track your order at any time by:
                </p>
                <ul className="space-y-3">
                  <li className="flex">
                    <ArrowRight className="text-primary h-5 w-5 mt-0.5 mr-2 flex-shrink-0" />
                    <p className="text-olive">Logging into your account and visiting the "Order History" page</p>
                  </li>
                  <li className="flex">
                    <ArrowRight className="text-primary h-5 w-5 mt-0.5 mr-2 flex-shrink-0" />
                    <p className="text-olive">Using the "Track Your Order" feature on our website</p>
                  </li>
                  <li className="flex">
                    <ArrowRight className="text-primary h-5 w-5 mt-0.5 mr-2 flex-shrink-0" />
                    <p className="text-olive">Clicking the tracking link in your shipment confirmation email</p>
                  </li>
                </ul>
              </div>
            </div>
          </div>

          {/* Returns Policy */}
          <div className="bg-white shadow-md rounded-lg p-6 md:p-8 mb-8">
            <div className="flex items-center mb-6">
              <div className="bg-primary/10 p-3 rounded-full mr-4">
                <RefreshCw className="text-primary h-6 w-6" />
              </div>
              <h2 className="font-heading text-forest text-2xl font-bold">Returns Policy</h2>
            </div>

            <div className="space-y-6">
              <div className="border-b border-gray-200 pb-6">
                <h3 className="font-heading text-forest text-xl font-semibold mb-3">24-Hour Return Policy</h3>
                <p className="text-olive">
                  We stand behind the quality of our products. If you're not completely satisfied with your purchase due to damaged or defective items, we accept returns within 24 hours of delivery for a full refund or replacement.
                </p>
                <div className="bg-amber-50 border border-amber-200 rounded-lg p-4 mt-4">
                  <p className="text-amber-800 font-medium">
                    <strong>Important:</strong> Returns are only accepted for damaged or defective products with proper visual documentation within 24 hours of delivery.
                  </p>
                </div>
              </div>

              <div className="border-b border-gray-200 pb-6">
                <h3 className="font-heading text-forest text-xl font-semibold mb-3">Return Process</h3>
                <p className="text-olive mb-4">
                  To initiate a return for damaged or defective products, please follow these steps:
                </p>
                <ol className="list-decimal list-inside space-y-3 text-olive">
                  <li>Contact our customer service team via email or phone within 24 hours of receiving your order</li>
                  <li>Provide your order number and clear photos/videos showing the damaged or defective items</li>
                  <li>Our team will review the visual evidence and guide you through the process</li>
                  <li>If approved, we'll provide a return shipping label or arrange pickup</li>
                  <li>Package the items securely in their original packaging if possible</li>
                </ol>
              </div>

              <div className="border-b border-gray-200 pb-6">
                <h3 className="font-heading text-forest text-xl font-semibold mb-3">Refund Conditions</h3>
                <p className="text-olive mb-4">
                  Refunds are processed under the following conditions:
                </p>
                <ul className="space-y-3">
                  <li className="flex">
                    <ArrowRight className="text-primary h-5 w-5 mt-0.5 mr-2 flex-shrink-0" />
                    <div>
                      <span className="font-medium text-forest">Damaged Products:</span>
                      <p className="text-olive">Full refund provided only if the product was not collected/accepted by the customer due to visible damage</p>
                    </div>
                  </li>
                  <li className="flex">
                    <ArrowRight className="text-primary h-5 w-5 mt-0.5 mr-2 flex-shrink-0" />
                    <div>
                      <span className="font-medium text-forest">Visual Documentation Required:</span>
                      <p className="text-olive">Clear photos or videos showing the damage must be provided within 24 hours</p>
                    </div>
                  </li>
                  <li className="flex">
                    <ArrowRight className="text-primary h-5 w-5 mt-0.5 mr-2 flex-shrink-0" />
                    <div>
                      <span className="font-medium text-forest">Collected Products:</span>
                      <p className="text-olive">Products that have been collected and accepted by the customer are not eligible for refund unless proven defective</p>
                    </div>
                  </li>
                </ul>
              </div>

              <div className="border-b border-gray-200 pb-6">
                <h3 className="font-heading text-forest text-xl font-semibold mb-3">Special Considerations for Perishable Items</h3>
                <p className="text-olive mb-4">
                  For perishable products, please contact us immediately upon delivery if there are any issues with quality or condition:
                </p>
                <ul className="space-y-3">
                  <li className="flex">
                    <ArrowRight className="text-primary h-5 w-5 mt-0.5 mr-2 flex-shrink-0" />
                    <p className="text-olive">Report any issues within 24 hours of delivery with photographic evidence</p>
                  </li>
                  <li className="flex">
                    <ArrowRight className="text-primary h-5 w-5 mt-0.5 mr-2 flex-shrink-0" />
                    <p className="text-olive">Refunds are only applicable if the product was rejected at the time of delivery</p>
                  </li>
                  <li className="flex">
                    <ArrowRight className="text-primary h-5 w-5 mt-0.5 mr-2 flex-shrink-0" />
                    <p className="text-olive">Our quality team will review each case based on the provided visual documentation</p>
                  </li>
                </ul>
              </div>

              <div className="border-b border-gray-200 pb-6">
                <h3 className="font-heading text-forest text-xl font-semibold mb-3">Non-Returnable Items</h3>
                <p className="text-olive mb-4">
                  For health and safety reasons, the following items cannot be returned:
                </p>
                <ul className="space-y-3">
                  <li className="flex">
                    <ArrowRight className="text-primary h-5 w-5 mt-0.5 mr-2 flex-shrink-0" />
                    <p className="text-olive">Products that have been collected and accepted by the customer</p>
                  </li>
                  <li className="flex">
                    <ArrowRight className="text-primary h-5 w-5 mt-0.5 mr-2 flex-shrink-0" />
                    <p className="text-olive">Products with broken seals or opened packaging (unless damaged during transit)</p>
                  </li>
                  <li className="flex">
                    <ArrowRight className="text-primary h-5 w-5 mt-0.5 mr-2 flex-shrink-0" />
                    <p className="text-olive">Personalized or custom-made products</p>
                  </li>
                  <li className="flex">
                    <ArrowRight className="text-primary h-5 w-5 mt-0.5 mr-2 flex-shrink-0" />
                    <p className="text-olive">Products reported after the 24-hour window</p>
                  </li>
                </ul>
              </div>

              <div>
                <h3 className="font-heading text-forest text-xl font-semibold mb-3">Refund Process</h3>
                <p className="text-olive mb-4">
                  Once we approve your return request based on visual evidence, we'll process your refund:
                </p>
                <ul className="space-y-3">
                  <li className="flex">
                    <ArrowRight className="text-primary h-5 w-5 mt-0.5 mr-2 flex-shrink-0" />
                    <p className="text-olive">Refunds are processed within 5-7 business days after approval</p>
                  </li>
                  <li className="flex">
                    <ArrowRight className="text-primary h-5 w-5 mt-0.5 mr-2 flex-shrink-0" />
                    <p className="text-olive">Credit will be applied to your original payment method</p>
                  </li>
                  <li className="flex">
                    <ArrowRight className="text-primary h-5 w-5 mt-0.5 mr-2 flex-shrink-0" />
                    <p className="text-olive">You'll receive an email notification when your refund is processed</p>
                  </li>
                  <li className="flex">
                    <ArrowRight className="text-primary h-5 w-5 mt-0.5 mr-2 flex-shrink-0" />
                    <p className="text-olive">Shipping charges are refunded only for products damaged during transit</p>
                  </li>
                </ul>
                <div className="bg-red-50 border border-red-200 rounded-lg p-4 mt-4">
                  <p className="text-red-800">
                    <strong>Please Note:</strong> Refunds are only applicable for products that were not collected by the customer due to damage or defects. Once a product is accepted and collected, no refunds will be processed unless the product is proven to be defective with proper documentation.
                  </p>
                </div>
              </div>
            </div>
          </div>

          {/* Questions Box */}
          <div className="bg-primary/10 rounded-lg p-6 md:p-8 flex flex-col md:flex-row items-center justify-between">
            <div className="flex items-start mb-4 md:mb-0">
              <AlertCircle className="text-primary h-6 w-6 mr-3 mt-0.5" />
              <div>
                <h3 className="font-heading text-forest text-xl font-semibold mb-1">Have Questions?</h3>
                <p className="text-olive">Our customer service team is here to help with any shipping or return inquiries.</p>
              </div>
            </div>
            <a
              href="/contact"
              className="inline-block px-6 py-3 bg-primary text-white font-medium rounded-md hover:bg-primary/90 transition-colors whitespace-nowrap"
            >
              Contact Us
            </a>
          </div>
        </div>
      </div>
    </div>
  );
}