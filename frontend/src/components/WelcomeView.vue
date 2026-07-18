<script setup lang="ts">
import { computed } from 'vue'
import { useDataStore } from '../stores/dataStore'
import { useUiStore } from '../stores/uiStore'

const data = useDataStore()
const ui = useUiStore()

const LUTAML_LOGO_LIGHT = 'https://raw.githubusercontent.com/lutaml/branding/refs/heads/main/svg/lutaml-logo_logo-icon-light.svg'
const LUTAML_LOGO_DARK = 'https://raw.githubusercontent.com/lutaml/branding/refs/heads/main/svg/lutaml-logo_logo-icon-dark.svg'

// Honour a user-defined square logo from the static-site config
// (metadata.appearance.logos.square.{light,dark}) before falling back
// to the default LutaML branding. Mirrors AppSidebar.vue so the
// welcome screen and the sidebar never disagree about which logo to
// show.
const welcomeLogo = computed(() => {
  const logos = data.metadata?.appearance?.logos
  if (logos?.square) {
    const variant = ui.darkMode ? logos.square.dark : logos.square.light
    if (variant?.url) return variant.url
    if (variant?.path) return variant.path
  }
  return ui.darkMode ? LUTAML_LOGO_DARK : LUTAML_LOGO_LIGHT
})

function formatDate(isoString?: string): string {
  if (!isoString) return ''
  try {
    const date = new Date(isoString)
    return date.toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' })
  } catch {
    return isoString
  }
}
</script>

<template>
  <div class="view-welcome">
    <div class="welcome-logo">
      <img
        :src="welcomeLogo"
        :alt="data.metadata?.title || 'Logo'"
        width="48"
        height="48"
      />
    </div>
    <h1 class="welcome-title">{{ data.metadata?.title || 'UML Model Browser' }}</h1>
    <p class="welcome-subtitle">Explore UML model packages, classes, and associations</p>

    <div class="welcome-stats" v-if="data.metadata">
      <div class="welcome-stat">
        <div class="welcome-stat-value">{{ data.metadata.statistics.packages }}</div>
        <div class="welcome-stat-label">Packages</div>
      </div>
      <div class="welcome-stat">
        <div class="welcome-stat-value">{{ data.metadata.statistics.classes }}</div>
        <div class="welcome-stat-label">Classes</div>
      </div>
      <div class="welcome-stat">
        <div class="welcome-stat-value">{{ data.metadata.statistics.attributes }}</div>
        <div class="welcome-stat-label">Attributes</div>
      </div>
      <div class="welcome-stat">
        <div class="welcome-stat-value">{{ data.metadata.statistics.associations }}</div>
        <div class="welcome-stat-label">Associations</div>
      </div>
    </div>

    <div class="welcome-meta" v-if="data.metadata">
      <div class="meta-item">
        <span class="meta-label">Generator</span>
        <span class="meta-value">{{ data.metadata.generator }}</span>
      </div>
      <div class="meta-item" v-if="data.metadata.version">
        <span class="meta-label">Version</span>
        <span class="meta-value">{{ data.metadata.version }}</span>
      </div>
      <div class="meta-item" v-if="data.metadata.generated">
        <span class="meta-label">Generated</span>
        <span class="meta-value">{{ formatDate(data.metadata.generated) }}</span>
      </div>
    </div>

    <p class="welcome-actions">Select a package from the sidebar or press <kbd>/</kbd> to search</p>
  </div>
</template>
