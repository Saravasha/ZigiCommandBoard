// app.jsx
import { useEffect, useState } from "react";

export default function App() {
  const [commands, setCommands] = useState([]);
  const [visible, setVisible] = useState(false);

  useEffect(() => {
    window.api.getCommands().then(setCommands);
  }, []);

  useEffect(() => {
    window.api.onDashboardVisible(setVisible);
  }, []);

  return (
    <div
      className={visible ? "board visible" : "board hidden"}
      style={{ display: "grid", gridTemplateColumns: "repeat(3, 1fr)" }}
    >
      {commands.map((cmd) => (
        <button key={cmd.id} onClick={() => window.api.runCommand(cmd.id)}>
          <h3>{cmd.name}</h3>
          <p>{cmd.hotkey}</p>
        </button>
      ))}
    </div>
  );
}
