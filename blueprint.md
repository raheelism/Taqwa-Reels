# Taqwa Reels - Blueprint

## 1. Vision & Overview

**Working Name:** Taqwa Reels

**Vision:** To build a premium-feeling Flutter mobile app that allows users to generate beautiful Islamic reels using Quran verses, translations, recitations, and cinematic backgrounds—fully powered by free APIs.

**Core Principles:**

*   **Elegant & Spiritual:** The app will have a clean, minimal, and high-end design.
*   **User-Friendly:** The process of creating a reel will be extremely simple and intuitive, achievable in under 60 seconds.
*   **Flutter Optimized:** The app will be built with modern Flutter best practices, ensuring a smooth and responsive experience.

## 2. Current Plan & Features (Version 1 - MVP)

This section outlines the features and design being implemented in the current version of the application.

### 2.1. Style, Design, and Features

*   **UI/UX:**
    *   Dark mode default with a Gold accent (#C8A951).
    *   Smooth transitions and soft, rounded containers.
    *   Simple, 5-6 step creation flow (Home -> Create -> Customize -> Preview -> Export -> Share).
*   **Core Functionality:**
    *   **Surah & Ayah Selection:** Select Surah and Ayah range (up to 5-10 ayahs).
    *   **Reciter Selection:** Choose from multiple reciters (e.g., Mishary Alafasy, Al-Sudais).
    *   **Translation Options:** Toggle translation, select language, and customize font/size/position.
    *   **Backgrounds:** Search for backgrounds (from Pexels), use presets, or upload user's own. Adjust blur, brightness, and tint.
    *   **Text Customization:** Adjust fonts, size, color, and style for both Arabic and translation.
    *   **Drag & Position:** Use a `Stack` and `Draggable` widgets to position text blocks.
    *   **Logo/Watermark:** Upload a logo, resize, and adjust opacity.
    *   **Export:** Export in 9:16, 1:1, or 16:9 aspect ratios at 720p.
*   **Preset Themes:**
    *   Golden Mosque
    *   Night Spiritual
    *   Minimal White
    *   Emotional Sunset

### 2.2. Development Plan

1.  **Project Setup:**
    *   [x] Create `blueprint.md` to track project progress.
    *   [ ] Set up the folder structure.
    *   [ ] Add initial dependencies (`video_player`, `ffmpeg_kit_flutter`, `google_fonts`, `provider`).
    *   [ ] Implement the base Material 3 theme and typography.
2.  **Home Screen:**
    *   [ ] Design the main landing page with a "Create Reel" call-to-action.
3.  **Create Screen (Surah & Ayah Selection):**
    *   [ ] Implement UI for selecting Surah and Ayah range.
    *   [ ] Integrate with the AlQuran Cloud API to fetch Surah data.
4.  **Editor Screen:**
    *   [ ] Develop the main editor interface with a live preview.
    *   [ ] Implement the drag-and-drop system for text blocks.
    *   [ ] Add customization panels for text, background, and reciter.
5.  **Export & Share:**
    *   [ ] Build the FFmpeg command generation logic.
    *   [ ] Implement the video rendering process with a progress indicator.

## 3. Technical Architecture

*   **Frontend:** Flutter 3+, Dart
*   **State Management:** Provider
*   **Video Engine:**
    *   `video_player` for previews.
    *   `ffmpeg_kit_flutter` for rendering.
*   **APIs:**
    *   **Quran:** AlQuran Cloud API
    *   **Backgrounds:** Pexels API

## 4. Folder Structure

```
lib/
 ├── core/
 ├── features/
 │     ├── home/
 │     ├── create/
 │     ├── editor/
 │     ├── export/
 ├── services/
 ├── models/
 ├── providers/
 ├── utils/
 └── theme/
```
