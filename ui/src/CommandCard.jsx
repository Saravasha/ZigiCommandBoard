export default function CommandCard({ cmd }) {
  return (
    <div
      style={{
        background: "#1e1e1e",
        padding: "16px",
        borderRadius: "12px",
        border: "1px solid #2a2a2a",
        cursor: "pointer",
      }}
    >
      <h2 style={{ margin: 0 }}>{cmd.id}</h2>
      <h3 style={{ margin: 0 }}>{cmd.name}</h3>

      <p style={{ margin: "8px 0", opacity: 0.7 }}>{cmd.description}</p>

      <div style={{ fontSize: "12px", opacity: 0.5 }}>{cmd.hotkey}</div>
    </div>
  );
}
