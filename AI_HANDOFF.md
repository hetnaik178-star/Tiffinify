# Tiffinify — AI Handoff Document

## Kya hai
Meal subscription / tiffin delivery app (India). Users weekly/monthly plan lete
hain, daily menu dekhte hain, har meal customize karte hain (spice/oil/no
onion-garlic/extra roti), festival specials pre-order karte hain, live order
status track karte hain.

## Stack
- Flutter (Android + iOS) • Riverpod • Dio • Socket.IO client
- Backend (banana hai): Node.js + Express + PostgreSQL + Redis + FCM + Razorpay

## Architecture
lib/core (constants, network/dio+interceptor, theme, utils)
→ lib/data (models [DB schema mirrors], services [api_service me `mockMode`
  flag — true = demo data, false = real API], repositories)
→ lib/providers (Riverpod) → lib/features (splash, onboarding, auth, home,
  customization, subscription, cart_checkout, order_status, festival_special,
  profile, notifications) → lib/widgets

## API mapping (PDF endpoints → code)
POST /auth/otp/send ............... ApiService.sendOtp()
POST /auth/otp/verify ............. ApiService.verifyOtp()
GET  /menu/today .................. ApiService.getTodayMenu()
GET  /menu/festival ............... ApiService.getFestivalMenus()
POST /subscriptions ............... ApiService.createSubscription()
PATCH /subscriptions/:id/pause .... ApiService.pauseSubscription()
POST /subscriptions/:id/skip ...... ApiService.skipDay()
POST /orders ...................... ApiService.placeOrder()
PATCH /orders/:id/customize ....... ApiService.customizeOrder()
POST /payments/create-order ....... ApiService.createPaymentOrder()
GET  /users/me/customization-template → getCustomizationTemplate()
POST /notifications/register-device → registerDevice()
Socket: 'order:status' {orderId, status} → SocketService

## Demo mode
mockMode = true → OTP: 1234, payment auto-success, tracking har 5s advance.

## Conventions
- Hinglish UI copy • Colors: AppColors (masala/turmeric/leaf/ink)
- Fonts: Baloo 2 (display) + Nunito Sans (body) via google_fonts
- Har service me mockMode pattern follow karo

## Next tasks (build phases)
1. Backend MVP: Node+Express+PostgreSQL — upar wale endpoints + tables:
   users, subscriptions, menu_items, customization_options,
   user_customization_templates, orders, order_items, payments,
   festival_menus, notifications
2. JWT short-expiry + refresh tokens, OTP rate-limit, signed payment webhook
3. Admin panel (React + Tailwind): menu publish, festival builder, analytics
4. FCM push + Razorpay live integration (pubspec me commented deps uncomment)