import { useEffect, useState } from "react";

export default function App() {
  const [commands, setCommands] = useState([]);

  useEffect(() => {
    window.api.getCommands().then(setCommands);
  }, []);

  return (
    <div style={{ display: "grid", gridTemplateColumns: "repeat(3, 1fr)" }}>
      {commands.map((cmd) => (
        <button key={cmd.id} onClick={() => window.api.runCommand(cmd.id)}>
          <h3>{cmd.name}</h3>
          <p>{cmd.hotkey}</p>
        </button>
      ))}
    </div>
  );
}
