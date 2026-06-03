// app.jsx
import { useEffect, useState } from "react";

import "./App.scss";
// import "./assets/appReady.wav";

export default function App() {
  const [commands, setCommands] = useState([]);
  const [visible, setVisible] = useState(false);

  useEffect(() => {
    window.api.onAppReady(() => {
      console.log("app ready");
      const audio = new Audio("./assets/appReady.wav");
      audio.volume = 0.5;
      audio.play();
    });
  }, []);

  useEffect(() => {
    window.api.getCommands().then(setCommands);
  }, []);

  useEffect(() => {
    window.api.onDashboardVisible(setVisible);
  }, []);

  return (
    <div className="honeycomb">
      {commands.map((cmd) => (
        <div
          key={cmd.id}
          className="cell"
          style={{
            left: cmd.x,
            top: cmd.y,
          }}
        >
          <button key={cmd.id} onClick={() => window.api.runCommand(cmd.id)}>
            {cmd.name}
          </button>
        </div>
      ))}
    </div>
  );
}
