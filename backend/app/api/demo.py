"""Demo endpoints for the Reviewer Control Panel."""

from fastapi import APIRouter
from fastapi.responses import HTMLResponse

router = APIRouter(tags=["demo"])

html_content = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SevakAI - Reviewer Control Panel</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .loading { opacity: 0.5; pointer-events: none; }
        #logs { max-height: 300px; overflow-y: auto; }
    </style>
</head>
<body class="bg-slate-900 text-slate-200 min-h-screen p-8 font-sans">
    <div class="max-w-4xl mx-auto">
        <header class="mb-8 border-b border-slate-700 pb-4">
            <h1 class="text-3xl font-bold text-white tracking-tight">SevakAI Reviewer Control Panel</h1>
            <p class="text-slate-400 mt-2">Generate mock data and trigger system flows for live demonstrations.</p>
        </header>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <!-- Mock Data Generation -->
            <div class="bg-slate-800 p-6 rounded-xl border border-slate-700 shadow-lg">
                <h2 class="text-xl font-semibold mb-4 text-emerald-400 flex items-center">
                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path></svg>
                    Generate Test Data
                </h2>
                <div class="space-y-3">
                    <button onclick="createMockVolunteer()" class="w-full bg-slate-700 hover:bg-slate-600 text-left px-4 py-3 rounded-lg transition-colors flex justify-between items-center group">
                        <span>1. Create Mock Volunteer</span>
                        <span class="text-xs bg-slate-900 text-slate-400 px-2 py-1 rounded opacity-0 group-hover:opacity-100 transition-opacity">POST /volunteers</span>
                    </button>
                    <button onclick="createMockCamp()" class="w-full bg-slate-700 hover:bg-slate-600 text-left px-4 py-3 rounded-lg transition-colors flex justify-between items-center group">
                        <span>2. Create Mock Camp</span>
                        <span class="text-xs bg-slate-900 text-slate-400 px-2 py-1 rounded opacity-0 group-hover:opacity-100 transition-opacity">POST /camps</span>
                    </button>
                    <button onclick="createMockNeed()" class="w-full bg-slate-700 hover:bg-slate-600 text-left px-4 py-3 rounded-lg transition-colors flex justify-between items-center group">
                        <span>3. Create Mock Need (Emergency)</span>
                        <span class="text-xs bg-slate-900 text-slate-400 px-2 py-1 rounded opacity-0 group-hover:opacity-100 transition-opacity">POST /needs</span>
                    </button>
                </div>
            </div>

            <!-- Scenarios & Tests -->
            <div class="bg-slate-800 p-6 rounded-xl border border-slate-700 shadow-lg">
                <h2 class="text-xl font-semibold mb-4 text-blue-400 flex items-center">
                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path></svg>
                    Scenarios & AI
                </h2>
                <div class="space-y-3">
                    <button onclick="seedDemoScenario()" class="w-full bg-blue-600/20 hover:bg-blue-600/30 border border-blue-500/30 text-left px-4 py-3 rounded-lg transition-colors flex justify-between items-center group">
                        <span class="text-blue-200 font-medium">✨ Full Demo Scenario (Auto-Assign)</span>
                        <span class="text-xs bg-slate-900 text-slate-400 px-2 py-1 rounded opacity-0 group-hover:opacity-100 transition-opacity">Full Lifecycle</span>
                    </button>
                    <button onclick="runAiTriage()" class="w-full bg-slate-700 hover:bg-slate-600 text-left px-4 py-3 rounded-lg transition-colors flex justify-between items-center group">
                        <span>Run AI Triage Test</span>
                        <span class="text-xs bg-slate-900 text-slate-400 px-2 py-1 rounded opacity-0 group-hover:opacity-100 transition-opacity">POST /debug/ai-triage</span>
                    </button>
                </div>

                <h2 class="text-xl font-semibold mt-8 mb-4 text-purple-400 flex items-center">
                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path></svg>
                    Quick Links
                </h2>
                <div class="flex space-x-3">
                    <a href="/docs" target="_blank" class="flex-1 bg-slate-700 hover:bg-slate-600 text-center px-4 py-2 rounded-lg transition-colors">Swagger API</a>
                    <a href="/health" target="_blank" class="flex-1 bg-slate-700 hover:bg-slate-600 text-center px-4 py-2 rounded-lg transition-colors">Health Check</a>
                </div>
            </div>
        </div>

        <!-- Activity Log -->
        <div class="mt-8 bg-black/50 rounded-xl border border-slate-700 p-4">
            <div class="flex justify-between items-center mb-2">
                <h3 class="text-sm font-semibold text-slate-400 uppercase tracking-wider">Activity Log</h3>
                <button onclick="document.getElementById('logs').innerHTML=''" class="text-xs text-slate-500 hover:text-slate-300">Clear</button>
            </div>
            <div id="logs" class="font-mono text-xs space-y-2"></div>
        </div>
    </div>

    <script>
        const API_BASE = "/api/v1";

        function log(message, isError=false, data=null) {
            const logs = document.getElementById('logs');
            const color = isError ? 'text-red-400' : 'text-emerald-400';
            const time = new Date().toLocaleTimeString();
            let html = `<div class="border-l-2 ${isError ? 'border-red-500' : 'border-emerald-500'} pl-2 py-1 mb-1 bg-slate-800/50 rounded-r">`;
            html += `<span class="text-slate-500 mr-2">[${time}]</span>`;
            html += `<span class="${color}">${message}</span>`;
            if (data) {
                html += `<pre class="mt-1 text-slate-400 ml-12 overflow-x-auto p-1 bg-black/30 rounded border border-slate-700/50">${JSON.stringify(data, null, 2)}</pre>`;
            }
            html += `</div>`;
            logs.innerHTML = html + logs.innerHTML;
        }

        async function apiCall(method, endpoint, body) {
            try {
                const response = await fetch(endpoint, {
                    method: method,
                    headers: { 'Content-Type': 'application/json' },
                    body: body ? JSON.stringify(body) : undefined
                });
                const data = await response.json();
                if (!response.ok) throw new Error(data.detail || data.error || 'API Error');
                return data;
            } catch (err) {
                log(`Failed: ${method} ${endpoint}`, true, err.message);
                throw err;
            }
        }

        function randomPhone() {
            return "+91" + Math.floor(6000000000 + Math.random() * 3999999999).toString();
        }

        async function createMockVolunteer() {
            const num = Math.floor(1000 + Math.random() * 9000);
            const payload = {
                name: `Demo Volunteer ${num}`,
                phone_number: randomPhone(),
                whatsapp_number: randomPhone(),
                gender: "Unspecified",
                qualification: "First Aid Certified",
                skills: ["medical", "rescue"],
                location: { pincode: "411014", lat: 18.5204 + (Math.random()*0.1 - 0.05), lng: 73.8567 + (Math.random()*0.1 - 0.05), label: "Pune Central" },
                availability: true
            };
            try {
                const res = await apiCall("POST", `${API_BASE}/volunteers`, payload);
                log(`Created Mock Volunteer: ${res.data.name}`, false, { id: res.data.id, phone: res.data.phone_number });
                return res.data;
            } catch (e) {}
        }

        async function createMockCamp() {
            const num = Math.floor(100 + Math.random() * 900);
            const payload = {
                name: `Relief Camp Alpha-${num}`,
                zone_id: "MH-PUNE-01",
                location: { pincode: "411001", lat: 18.5204, lng: 73.8567, label: "Main Stadium" },
                capacity: 500,
                current_occupancy: Math.floor(Math.random() * 200),
                notes: "Generated by demo script"
            };
            try {
                const res = await apiCall("POST", `${API_BASE}/camps`, payload);
                log(`Created Mock Camp: ${res.data.name}`, false, { id: res.data.id });
                return res.data;
            } catch (e) {}
        }

        async function createMockNeed() {
            const types = ["medical", "food", "water", "rescue"];
            const urgencies = ["high", "medium", "low"];
            const payload = {
                need_type: types[Math.floor(Math.random() * types.length)],
                urgency: urgencies[Math.floor(Math.random() * urgencies.length)],
                title: "Emergency assistance required",
                description: "Simulated emergency reported via demo panel. Multiple individuals affected.",
                affected_count: Math.floor(1 + Math.random() * 15),
                location: { pincode: "411028", lat: 18.5 + (Math.random()*0.1), lng: 73.8 + (Math.random()*0.1), label: "Affected Area" },
                contact_info: { name: "Demo Reporter", phone: randomPhone() },
                source: "DEMO_PANEL"
            };
            try {
                const res = await apiCall("POST", `${API_BASE}/needs`, payload);
                log(`Created Mock Need: [${res.data.urgency}] ${res.data.need_type}`, false, { id: res.data.id });
                return res.data;
            } catch (e) {}
        }

        async function seedDemoScenario() {
            log("Starting Full Lifecycle Scenario...");
            
            // 1. Create Volunteer
            const vol = await createMockVolunteer();
            if (!vol) return;

            // 2. Create Need
            const need = await createMockNeed();
            if (!need) return;

            // 3. Assign
            try {
                const assignPayload = { need_id: need.id, volunteer_id: vol.id };
                const assignedNeed = await apiCall("POST", `${API_BASE}/assign`, assignPayload);
                log(`Assigned Volunteer to Need successfully!`, false, { volunteer_id: vol.id, need_id: need.id });
            } catch (e) {
                log("Assignment failed during scenario.", true);
            }
        }

        async function runAiTriage() {
            const payload = {
                raw_text: "URGENT: Flooding at Viman Nagar main road. 3 people trapped in a car, need rescue immediately! Sent by Ravi.",
                source: "whatsapp",
                connectivity_available: true
            };
            try {
                const res = await apiCall("POST", `/debug/ai-triage`, payload);
                log("AI Triage processed successfully!", false, res);
            } catch (e) {}
        }
    </script>
</body>
</html>
"""

@router.get("", response_class=HTMLResponse)
async def get_demo_page():
    """Serve the interactive Reviewer Control Panel."""
    return HTMLResponse(content=html_content)
