-- 1. Listar todas las solicitudes abiertas por cliente

SELECT 
    c.name as name,
    r.title,
    r.description,
    r.created_at,
    r.priority,
    r.state
FROM requests r
JOIN clients c ON r.client_id = c.client_id
WHERE r.state = 'abierta'
ORDER BY c.name, r.created_at;

-- 2. Promedio de tiempo de resolución de solicitudes

SELECT 
    AVG(TIMESTAMPDIFF(DAY, r.created_at, r.closed_at)) AS dias_promedio
FROM requests r
WHERE r.state = 'cerrada' 
  AND r.closed_at IS NOT NULL
  AND r.closed_at >= r.created_at;

-- 3. Cantidad de solicitudes cerradas por agente en el último mes

SELECT 
    u.name AS agente,
    COUNT(r.request_id) AS solicitudes_cerradas
FROM requests r
JOIN users u ON r.agent_id = u.user_id
WHERE r.state = 'cerrada' 
  AND r.closed_at >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY u.name
ORDER BY solicitudes_cerradas DESC;

-- 4. Clientes con más solicitudes abiertas actualmente

SELECT 
    c.name AS cliente,
    COUNT(r.request_id) AS solicitudes_abiertas
FROM clients c
LEFT JOIN requests r 
    ON c.client_id = r.client_id 
   AND r.state IN ('abierta', 'en_proceso')
GROUP BY c.name
HAVING COUNT(r.request_id) > 0
ORDER BY solicitudes_abiertas DESC
LIMIT 10;

-- 5. Tiempo promedio de respuesta desde creación hasta primera atención

SELECT 
    AVG(TIMESTAMPDIFF(DAY, r.created_at, c.changed_at)) AS dias_promedio_respuesta
FROM requests r
JOIN (
    SELECT request_id, MIN(changed_at) AS changed_at
    FROM change_history
    WHERE modified_field = 'state' 
      AND new_value != 'abierta'
    GROUP BY request_id
) c ON r.request_id = c.request_id;