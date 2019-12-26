---
to: "<%= name.split('::').length > 1 ? 'app/javascript/packs/components/'+ h.changeCase.lower(name.split('::')[0]) +'/'+ h.changeCase.paramCase(h.inflection.demodulize(name)) +'-list.js' : 'app/javascript/packs/components/'+ h.changeCase.paramCase(h.inflection.demodulize(name)) +'-list.js' %>"
unless_exists: true
---
import { html, css } from 'lit-element';
import { BaseList } from '../base-list.js'
import edit from '../images/edit.svg'
import del from '../images/delete.svg'
import copy from '../images/copy.svg'

class <%= h.inflection.demodulize(name) %>List extends BaseList {
    constructor() {
        super();
        this.debug = false;
        this.buttonName = "Add <%= h.inflection.transform(name, ['demodulize','underscore','titleize']) %>";
    }

    static get styles() {
        return [
            super.styles, 
            css `
                .row-head {
                    background-color: #2A3F54;
                }
                .row-head th {
                    font-size: 15px;
                    color: #FFFFFF;
                    text-align: left;
                    padding: 5px 5px;
                }
                .row-data-even {
                    background-color: #F2F3F4;
                }
                .row-data-odd {
                    background-color: #FFFFFF;
                }
                .row-data td {
                    border-bottom: 1pt solid #AAB7B8;
                }
                .row-data td {
                    font-size: 14px;
                    text-align: left;
                    padding: 5px 5px;
                }
                .col-1 {
                    width: 10%;
                }<% fields.split(",").slice(1, fields.split(",").length).forEach(function (field, index) { %>
                .col-<%= index + 2 %> {
                    width: 20%;
                }<% }); %>
                .action {
                    text-align: center !important;
                }
                .action img:hover {
                    cursor: pointer;
                }
            `
        ];
    }

    get headerTemplate() {
        return html`
            <thead>
                <tr class='row-head'>
                    <th class="colnum">#</th><% fields.split(",").slice(1, fields.split(",").length).forEach(function (field) { %>
                    <th class="<%= field %>"><%= h.inflection.titleize(field) %></th><% }); %>
                    <th colspan="3" class="action">Action</th>
                </tr>
            </thead>
        `;
    }

    get dataTemplate() {
        return html`
            <tbody>
                ${this.data.map(
                        (u, idx) =>
                        html `
                            ${idx % 2 == 0?
                            html `
                                <tr class="row-data row-data-even">
                                    <td class="col-1">${idx+1}</td><% fields.split(",").slice(1, fields.split(",").length).forEach(function (field, index) { %>
                                    <td class="col-<%= index+2 %>">${u.<%= field %>}</td><% }); %>
                                    <td class="action"><img title="edit" src="${edit}" height="24" width="24" id="${u.id}" @click="${this.edit}"/></td>
                                    <td class="action"><img title="copy" src="${copy}" height="24" width="24" id="${u.id}" @click="${this.copy}"/></td>
                                    <td class="action"><img title="delete" src="${del}" height="24" width="24" id="${u.id}" @click="${this.confirmation}"/></td>
                                </tr>
                            `:
                            html `
                                <tr class="row-data row-data-odd">
                                    <td class="col-1">${idx+1}</td><% fields.split(",").slice(1, fields.split(",").length).forEach(function (field, index) { %>
                                    <td class="col-<%= index+2 %>">${u.<%= field %>}</td><% }); %>
                                    <td class="action"><img title="edit" src="${edit}" height="24" width="24" id="${u.id}" @click="${this.edit}"/></td>
                                    <td class="action"><img title="copy" src="${copy}" height="24" width="24" id="${u.id}" @click="${this.copy}"/></td>
                                    <td class="action"><img title="delete" src="${del}" height="24" width="24" id="${u.id}" @click="${this.confirmation}"/></td>
                                </tr>
                            `}
            			`,
					)
				}
            </tbody>
        `;
    }

    get footerTemplate() {
        return html`
            <tfoot>
                <tr><td colspan="6"><h3>Pagination Here</h3></td></tr>
            </tfoot>
        `;
    }

    add(e) {
        this.redirect("/<%= page_controller %>/page/<%= h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %>_new");
    }

    edit(e) {
        this.redirect("/<%= page_controller %>/page/<%= h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %>_edit/"+ e.target.id);
    }

    copy(e) {
        this.redirect("/<%= page_controller %>/page/<%= h.inflection.transform(name, [ 'demodulize', 'underscore' ]) %>_copy/"+ e.target.id);
    }

    async search() {
        let <%= fields.split(",")[1] %> = this.shadowRoot.getElementById("search").value;
        let data;
		try {
            if (<%= fields.split(",")[1] %> === '') {
                const response = await fetch(this.dataUrl);
                data = await response.json();
            } else {
                const response = await fetch(this.dataUrl + "/search?<%= fields.split(',')[1] %>="+  <%= fields.split(',')[1] %> + "&page=0");
                data = await response.json();
            }
		} catch (error) {
			console.error(error);
        }

        if (this.debug) {
            console.log(data.results);            
        }

		this.data = []
        data.results.forEach(function(item) {
            this.data.push(item);
        }, this);
    }

    confirmation(e) {
        let modal = this.shadowRoot.getElementById('modal');
        let state = {action:'delete', id: e.target.id};
        modal.open(state, "Delete Confirmation", "Are you sure to delete this <%= h.inflection.transform(name, ['demodulize','underscore','titleize']) %>?");
    }

    handleButtonYesEvent(e) {
        this.delete(e.detail.state.id);
    }

    async delete(id) {
        console.log(id);
        let data;
		try {
			const response = await fetch(this.dataUrl +'/'+ id + '/delete');
			data = await response.json();
		} catch (error) {
			console.error(error);
        }
        console.log(data);            
		this.reload();
    }
}
customElements.define('<%= h.changeCase.paramCase(h.inflection.demodulize(name)) %>-list', <%= h.inflection.demodulize(name) %>List);