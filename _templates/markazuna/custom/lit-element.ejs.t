---
to: app/javascript/packs/components/markazuna/<%= h.inflection.dasherize(name) %>.js
---
import { LitElement, html, css } from 'lit-element';

export class <%= h.inflection.camelize(name) %> extends LitElement {
    constructor() {
        super();
        this.state = {};
    }

    static get properties() {
		return {
            state: { type: Object },
		};
    }

    firstUpdated() {
        
    }

    static get styles() {
        return css `
            
        `;
    }

    render() {
        return html`
            
        `;
    }
}
customElements.define('<%= h.inflection.dasherize(name) %>', <%= h.inflection.camelize(name) %>);