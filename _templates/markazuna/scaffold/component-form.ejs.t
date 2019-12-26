---
to: "<%= name.split('::').length > 1 ? 'app/javascript/packs/components/'+ h.changeCase.lower(name.split('::')[0]) +'/'+ h.changeCase.paramCase(h.inflection.demodulize(name)) +'-form.js' : 'app/javascript/packs/components/'+ h.changeCase.paramCase(h.inflection.demodulize(name)) +'-form.js' %>"
unless_exists: true
---
import { LitElement, html, css } from 'lit-element';

export class <%= h.inflection.demodulize(name) %>Form extends LitElement {
    constructor() {
        super();
        this.<%= h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %> = {<% fields.split(',').forEach(function(field,idx){%>'<%= field %>':''<% if(idx < fields.split(',').length - 1) { %>, <% }}); %>};
        this.copy = 'false';
    }

    static get properties() {
        return {
            formAuthenticityToken: { type: String },
            actionUrl: { type: String },
            objectId: { type: String },
            copy: { type: String },
            <%= h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %>: { type: Object },
            title: { type: String },
            icon: { type: String },
        };
    }

    async firstUpdated() {
        if (this.objectId !== undefined) {
            let data;
            try {
                const response = await fetch(this.actionUrl +'/'+ this.objectId +'/edit');
                data = await response.json();
            } catch (error) {
                console.error(error);
            }
            console.log(data.payload);
            this.<%= h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %> = data.payload;
        }
    }

    static get styles() {
        return css `
            input[type=text], textarea, button {
                outline: none;
            }

            input[type=text]:focus, textarea:focus {
                box-shadow: 0 0 5px rgba(81, 203, 238, 1);
                padding: 3px 0px 3px 3px;
                margin: 5px 1px 3px 0px;
                border: 1px solid rgba(81, 203, 238, 1);
            }

            .form {
                background-color: #F6F7F8;
                border: 1px solid #D6D9DC;
                border-radius: 3px;

                width: 90%;
                padding: 40px;
                margin: 0 0 40px 0;
            }

            .form-row {
                margin-bottom: 10px;

                display: flex;
                flex-direction: row;
                flex-wrap: nowrap;
                justify-content: flex-start;
                align-items: center;
            }

            .form-row label {
                margin-top: 7px;
                margin-bottom: 15px;
                padding-right: 20px;

                width: 5%;
                text-align: right;
            }

            .form-row input[type='text'] {
                background-color: #FFFFFF;
                border: 1px solid #D6D9DC;
                border-radius: 3px;

                width: 50%;
                height: initial;

                padding: 7px;
                font-size: 14px;
            }

            .form-row .spacer {
                margin-top: 7px;
                margin-bottom: 15px;
                padding-right: 20px;

                width: 5%;
                text-align: right;
            }

            .form-row button {
                font-size: 14px;
                font-weight: bold;

                border: none;
                border-radius: 3px;

                padding: 10px 40px;
                cursor: pointer;

                margin-right: 5px;
            }

            .form-row button.submit {
                color: #FFFFFF;
                background-color: #2196F3;
            }

            .form-row button.cancel {
                color: #CFD8DC;
                background-color: #90A4AE;
            }

            .form-row button.submit:hover {
                background-color: #1E88E5;
            }

            .form-row button.cancel:hover {
                background-color: #78909C;
            }

            .form-row button:active {
                background-color: #407FC7;
            }
        `;
    }

    render() {
        return html`
            <div class='form'>
                <input id="<%= h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %>-id" type="hidden" .value="${this.<%= h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %>.id}"><% fields.split(",").slice(1, fields.split(",").length).forEach(function (field) { %>
                <div class='form-row'>
                    <label for='<%= h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %>-<%= field %>'><%= h.inflection.titleize(field) %></label>
                    <input id='<%= h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %>-<%= field %>' name='<%= h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %>-<%= field %>' type='text' .value="${this.<%= h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %>.<%= field %>}"/>
                </div><% }); %>
                <div class='form-row'>
                    <div class="spacer"></div>
                    <button class="submit" @click="${this.submit}">Submit</button>
                    <button class="cancel" @click="${this.cancel}">Cancel</button>
                </div>
            </div>
        `;
    }

    redirect(href) {
        window.location.href = href;
    }

    async postData(url = '', data = {}) {
        // Default options are marked with *
        const response = await fetch(url, {
            method: 'POST', // *GET, POST, PUT, DELETE, etc.
            mode: 'cors', // no-cors, *cors, same-origin
            cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
            credentials: 'same-origin', // include, *same-origin, omit
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': this.formAuthenticityToken
            },
            redirect: 'follow', // manual, *follow, error
            referrer: 'no-referrer', // no-referrer, *client
            body: JSON.stringify(data) // body data type must match "Content-Type" header
        });
        return await response.json(); // parses JSON response into native JavaScript objects
    }

    async putData(url = '', data = {}) {
        // Default options are marked with *
        const response = await fetch(url, {
            method: 'PUT', // *GET, POST, PUT, DELETE, etc.
            mode: 'cors', // no-cors, *cors, same-origin
            cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
            credentials: 'same-origin', // include, *same-origin, omit
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': this.formAuthenticityToken
            },
            redirect: 'follow', // manual, *follow, error
            referrer: 'no-referrer', // no-referrer, *client
            body: JSON.stringify(data) // body data type must match "Content-Type" header
        });
        return await response.json(); // parses JSON response into native JavaScript objects
    }

    async submit() {
        let objectId = this.shadowRoot.getElementById("<%= h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %>-id").value;
        if (objectId === '' || this.copy === 'true') {<% fields.split(",").slice(1, fields.split(",").length).forEach(function (field) { %>
            this.<%= h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %>.<%= field %> = this.shadowRoot.getElementById("<%= h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %>-<%= field %>").value;<% }); %>
            console.log(this.<%= h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %>);
            try {
                const data = await this.postData(this.actionUrl, this.<%= h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %>);
                console.log(JSON.stringify(data)); // JSON-string from `response.json()` call
                if (data.status == '200') {
                    this.redirect("/<%= page_controller %>/page/<%= h.inflection.transform(name, [ 'demodulize', 'underscore', 'pluralize' ]) %>");
                } else {

                }
            } catch (error) {
                console.error(error);
            }
        } else {<% fields.split(",").forEach(function (field) { %>
            this.<%= h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %>.<%= field %> = this.shadowRoot.getElementById("<%= h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %>-<%= field %>").value;<% }); %>
            console.log(this.<%= h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %>);
            try {
                const data = await this.putData(this.actionUrl +'/'+ this.<%= h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %>.id, this.<%= h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %>);
                console.log(JSON.stringify(data)); // JSON-string from `response.json()` call
                if (data.status == '200') {
                    this.redirect("/<%= page_controller %>/page/<%= h.inflection.transform(name, [ 'demodulize', 'underscore', 'pluralize' ]) %>");
                } else {

                }
            } catch (error) {
                console.error(error);
            }
        }
    }

    cancel() {
        this.redirect("/<%= page_controller %>/page/<%= h.inflection.transform(name, [ 'demodulize', 'underscore', 'pluralize' ]) %>");
    }
}
customElements.define("<%= h.changeCase.paramCase(h.inflection.demodulize(name)) %>-form", <%= h.inflection.demodulize(name) %>Form);