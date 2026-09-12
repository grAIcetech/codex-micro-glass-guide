<p align="center">
  <img src="../assets/graice-logo.svg" alt="grAIce" width="168">
</p>

<p align="center"><sub>© 2026 Michelle Juhanson · grAIce Tech</sub></p>

# Consent page setup

`index.html` is the consent-first intermediary page for launch links. It explains what
people receive, requires an explicit opt-in to communications from Michelle, promises an
unsubscribe path, and links onward to the public repository.

The page does not collect or store email addresses itself. Its subscribe button sends readers
to the owner's authenticated Substack subscribe route, where Substack handles the email,
consent record, and unsubscribe controls. This prevents the repository from implying that it
operates a separate mailing list.

## Deployment checklist

1. Keep the Substack subscribe destination in `index.html` aligned with the owner's current
   publication and sender identity. Do not replace it with a private API endpoint.
2. Test the subscribe route with a dedicated address: verify the sender identity, consent
   language, confirmation, unsubscribe link, and deletion/export process.
3. Point the Substack and LinkedIn calls-to-action at the deployed page URL. Do not publish a
   direct repository fallback alongside the consent-first CTA; the repository link is revealed
   on the page only after the visitor opts in and returns from Substack.

This source page is not a privacy policy, legal advice, or a substitute for Substack's terms.
The owner is responsible for the publication configuration, lawful consent language,
retention policy, and unsubscribe handling.
