package kr.or.dgit.ncs;

import java.awt.EventQueue;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.Properties;
import java.util.Set;
import java.util.Map.Entry;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;

import kr.or.dgit.ncs.jdbc.DBCon;
import kr.or.dgit.ncs.jdbc.LoadProperties;

public class SettingUI extends JFrame implements ActionListener {
	private static final long serialVersionUID = 1L;
	
	private JPanel contentPane;
	private JButton btnInit;
	private JButton btnExport;
	private JButton btnImport;

	public SettingUI() {
		setTitle("DB관리메뉴");
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 560, 100);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(10, 10, 10, 10));
		setContentPane(contentPane);
		contentPane.setLayout(new GridLayout(1, 0, 20, 0));
		
		btnInit = new JButton("초기화");
		btnInit.addActionListener(this);

		btnExport = new JButton("백업");
		btnExport.addActionListener(this);
		
		btnImport = new JButton("복원");
		btnImport.addActionListener(this);
		
		contentPane.add(btnInit);
		contentPane.add(btnExport);
		contentPane.add(btnImport);
	}

	public void actionPerformed(ActionEvent e) {
		if (e.getSource() == btnImport) {
			loadData();
		} else if (e.getSource() == btnExport) {
			saveData();
		} else if (e.getSource() == btnInit) {
			initSetting();
		}
	}
	
	private void saveData() {
		Setting.getInstance().executeSaveData();
		JOptionPane.showMessageDialog(this, "데이터 백업 완료");
	}

	private void loadData() {
		Setting.getInstance().executeLoadData();
		JOptionPane.showMessageDialog(this, "데이터 복원 완료");
	}

	private void initSetting() {
		Setting.getInstance().initSetting();
		JOptionPane.showMessageDialog(this, "초기화 완료");
	}

	public static void main(String[] args) {
		LoadProperties lp = new LoadProperties("resources/conf.properties");
		prnProperties(lp.getConfProp());
		System.out.println(DBCon.getConnection());
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				
				try {
					SettingUI main = new SettingUI();
					main.setVisible(true);
					main.addWindowListener(new WindowAdapter() {
						@Override
						public void windowClosing(WindowEvent e) {
							DBCon.close();
							JOptionPane.showMessageDialog(null, "Database 종료");
						}
					});
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}
	
	public static void prnProperties(Properties p) {
		Set<Entry<Object, Object>> setmap = p.entrySet();
		for (Entry<Object, Object> t : setmap) {
			System.out.println(t.getKey() + " : " + t.getValue());
		}
	}
}